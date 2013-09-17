package Tapper::RawSQL::TestrunDB::reports;

use strict;
use warnings;

sub web_list {

    my ( $hr_vals ) = @_;

    if ( !$hr_vals || !$hr_vals->{report_date_from} || !$hr_vals->{report_date_to} ) {
        require Carp;
        Carp::croak('missing parameters for sql statement: reports::web_list');
    }

    my %h_where;
    if ( $hr_vals->{suite_id} && @{$hr_vals->{suite_id}} ) {
        $h_where{suite_id} = 'suite_id IN (' . (join q#,#, @{$hr_vals->{suite_id}}) . ')';
    }
    if ( $hr_vals->{machine_name} ) {
        $h_where{machine_name} = 'machine_name = $machine_name$';
    }
    if ( $hr_vals->{successgrade} ) {
        $h_where{successgrade} = 'successgrade = $successgrade$';
    }
    if ( $hr_vals->{success_ratio} ) {
        $h_where{success_ratio} = 'success_ratio = $success_ratio$';
    }
    if ( $hr_vals->{owner} ) {
        $h_where{owner}      = '`owner` = $owner$';
        $h_where{owner_null} = '1 = 0';
    }

    $hr_vals->{report_date_from} = "$hr_vals->{report_date_from} 00:00:00";
    $hr_vals->{report_date_to}   = "$hr_vals->{report_date_to} 23:59:59";
    $h_where{report_date}       = 'r.created_at BETWEEN $report_date_from$ AND $report_date_to$';

    my $s_where = join "\nAND ", grep { $_ } @h_where{qw/ suite_id machine_name successgrade success_ratio owner report_date /};

    return {
        Pg => "
             (
                 -- reportgrouptestrun
                 SELECT
                     r.id                                       AS report_id,
                     CONCAT(
                         'testrun ',
                         rgt.testrun_id
                     )                                          AS grouping_id,
                     TO_CHAR( r.created_at, 'YYYY-MM-DD' )      AS report_date,
                     TO_CHAR( r.created_at, 'HH24:MM' )         AS report_time,
                     s.name                                     AS suite_name,
                     r.machine_name,
                     r.peeraddr,
                     r.successgrade,
                     FLOOR( CAST( r.success_ratio AS float ) )  AS success_ratio,
                     rgt.owner                                  AS report_owner,
                     (
                         SELECT
                             ri.created_at
                         FROM
                             report ri
                             JOIN reportgrouptestrun rgti
                                 ON ( rgti.report_id = ri.id )
                         WHERE
                             rgti.testrun_id = rgt.testrun_id
                             AND $s_where
                         ORDER BY
                             rgti.primaryreport DESC,
                             rgti.report_id DESC
                         LIMIT
                             1
                     )                                          AS primary_date,
                     NULLIF( rgt.primaryreport, 0 )             AS primaryreport
                 FROM
                     report r
                     JOIN suite s
                         ON ( s.id = r.suite_id )
                     JOIN reportgrouptestrun rgt
                         ON ( r.id = rgt.report_id )
                 WHERE
                     $s_where
             )
             UNION
             (
                 -- reportgrouparbitrary
                 SELECT
                     r.id                                       AS report_id,
                     CONCAT(
                         'arbitrary ',
                         rgt.arbitrary_id
                     )                                          AS grouping_id,
                     TO_CHAR( r.created_at, 'YYYY-MM-DD' )      AS report_date,
                     TO_CHAR( r.created_at, 'HH24:MM' )         AS report_time,
                     s.name                                     AS suite_name,
                     r.machine_name,
                     r.peeraddr,
                     r.successgrade,
                     FLOOR( CAST( r.success_ratio AS float ) )  AS success_ratio,
                     rgt.owner                                  AS report_owner,
                     (
                         SELECT
                             ri.created_at
                         FROM
                             report ri
                             JOIN reportgrouparbitrary rgti
                                 ON ( rgti.report_id = ri.id )
                         WHERE
                             rgti.arbitrary_id = rgt.arbitrary_id
                             AND $s_where
                         ORDER BY
                             rgti.primaryreport DESC,
                             rgti.report_id DESC
                         LIMIT
                             1
                     ) AS primary_date,
                     NULLIF( rgt.primaryreport, 0 )             AS primaryreport
                 FROM
                     report r
                     JOIN suite s
                         ON ( s.id = r.suite_id )
                     JOIN reportgrouparbitrary rgt
                         ON ( r.id = rgt.report_id )
                 WHERE
                     $s_where
             )
             UNION
             (
                 -- non related reports
                 SELECT
                     r.id                                           AS report_id,
                     ''                                             AS grouping_id,
                     TO_CHAR( r.created_at, 'YYYY-MM-DD' )          AS report_date,
                     TO_CHAR( r.created_at, 'HH24:MM' )             AS report_time,
                     s.name                                         AS suite_name,
                     r.machine_name,
                     r.peeraddr,
                     r.successgrade,
                     FLOOR( CAST( r.success_ratio AS float ) )      AS success_ratio,
                     ''                                             AS report_owner,
                     r.created_at                                   AS primary_date,
                     1                                              AS primaryreport
                 FROM
                     report r
                     JOIN suite s
                         ON ( s.id = r.suite_id )
                     LEFT JOIN reportgrouptestrun rgt
                         ON ( rgt.report_id = r.id )
                     LEFT JOIN reportgrouparbitrary rga
                         ON ( rga.report_id = r.id )
                 WHERE
                         rgt.report_id IS NULL
                     AND rga.report_id IS NULL
                     AND " . (join "\nAND ", grep { $_ } @h_where{qw/ suite_id machine_name successgrade success_ratio owner_null report_date /}) . "
             )
             ORDER BY
                 primary_date DESC,
                 grouping_id DESC,
                 primaryreport DESC,
                 report_id DESC
        ",
        SQLite => "
                -- reportgrouptestrun
                SELECT
                    r.id                                    AS report_id,
                    'testrun ' || rgt.testrun_id            AS grouping_id,
                    STRFTIME( '%Y-%m-%d', r.created_at )    AS report_date,
                    STRFTIME( '%H:%M', r.created_at )       AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    CAST( r.success_ratio AS INT )          AS success_ratio,
                    rgt.`owner`                             AS report_owner,
                    (
                        SELECT
                            ri.created_at
                        FROM
                            report ri
                            JOIN reportgrouptestrun rgti
                                ON ( rgti.report_id = ri.id )
                        WHERE
                            rgti.testrun_id = rgt.testrun_id
                            AND $s_where
                        ORDER BY
                            rgti.primaryreport DESC,
                            rgti.report_id DESC
                        LIMIT
                            1
                    )                                       AS primary_date,
                    IFNULL( rgt.primaryreport, 0 )          AS primaryreport
                FROM
                    report r
                    JOIN suite s
                        ON ( s.id = r.suite_id )
                    JOIN reportgrouptestrun rgt
                        ON ( r.id = rgt.report_id )
                WHERE
                    $s_where
            UNION
                -- reportgrouptestrun
                SELECT
                    r.id                                    AS report_id,
                    'arbitrary ' || rgt.arbitrary_id        AS grouping_id,
                    STRFTIME( '%Y-%m-%d', r.created_at )    AS report_date,
                    STRFTIME( '%H:%M', r.created_at )       AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    CAST( r.success_ratio AS INT )          AS success_ratio,
                    rgt.`owner`                             AS report_owner,
                    (
                        SELECT
                            ri.created_at
                        FROM
                            report ri
                            JOIN reportgrouparbitrary rgti
                                ON ( rgti.report_id = ri.id )
                        WHERE
                            rgti.arbitrary_id = rgt.arbitrary_id
                            AND $s_where
                        ORDER BY
                            rgti.primaryreport DESC,
                            rgti.report_id DESC
                        LIMIT
                            1
                    )                                       AS primary_date,
                    IFNULL( rgt.primaryreport, 0 )          AS primaryreport
                FROM
                    report r
                    JOIN suite s
                        ON ( s.id = r.suite_id )
                    JOIN reportgrouparbitrary rgt
                        ON ( r.id = rgt.report_id )
                WHERE
                    $s_where
            UNION
                -- non related reports
                SELECT
                    r.id                                    AS report_id,
                    ''                                      AS grouping_id,
                    STRFTIME( '%Y-%m-%d', r.created_at )    AS report_date,
                    STRFTIME( '%H:%M', r.created_at )       AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    CAST( r.success_ratio AS INT )          AS success_ratio,
                    ''                                      AS report_owner,
                    r.created_at                            AS primary_date,
                    1                                       AS primaryreport
                FROM
                    report r
                    JOIN suite s
                        ON ( s.id = r.suite_id )
                    LEFT JOIN reportgrouptestrun rgt
                        ON ( rgt.report_id = r.id )
                    LEFT JOIN reportgrouparbitrary rga
                        ON ( rga.report_id = r.id )
                WHERE
                        rgt.report_id IS NULL
                    AND rga.report_id IS NULL
                    AND " . (join "\nAND ", grep { $_ } @h_where{qw/ suite_id machine_name successgrade success_ratio owner_null report_date /}) . "
            ORDER BY
                primary_date DESC,
                grouping_id DESC,
                primaryreport DESC,
                report_id DESC
        ",
        mysql => "
            (
                -- reportgrouptestrun
                SELECT
                    r.id                                    AS report_id,
                    CONCAT(
                        'testrun ',
                        rgt.testrun_id
                    )                                       AS grouping_id,
                    DATE_FORMAT( r.created_at, '%Y-%m-%d' ) AS report_date,
                    DATE_FORMAT( r.created_at, '%H:%i' )    AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    FLOOR( r.success_ratio )                AS success_ratio,
                    rgt.`owner`                             AS report_owner,
                    (
                        SELECT
                            ri.created_at
                        FROM
                            testrundb.report ri
                            JOIN testrundb.reportgrouptestrun rgti
                                ON ( rgti.report_id = ri.id )
                        WHERE
                            rgti.testrun_id = rgt.testrun_id
                            AND $s_where
                        ORDER BY
                            rgti.primaryreport DESC,
                            rgti.report_id DESC
                        LIMIT
                            1
                    )                                       AS primary_date,
                    IFNULL( rgt.primaryreport, 0 )          AS primaryreport
                FROM
                    testrundb.report r
                    JOIN testrundb.suite s
                        ON ( s.id = r.suite_id )
                    JOIN testrundb.reportgrouptestrun rgt
                        ON ( r.id = rgt.report_id )
                WHERE
                    $s_where
            )
            UNION
            (
                -- reportgrouparbitrary
                SELECT
                    r.id                                    AS report_id,
                    CONCAT(
                        'arbitrary ',
                        rgt.arbitrary_id
                    )                                       AS grouping_id,
                    DATE_FORMAT( r.created_at, '%Y-%m-%d' ) AS report_date,
                    DATE_FORMAT( r.created_at, '%H:%i' )    AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    FLOOR( r.success_ratio )                AS success_ratio,
                    rgt.`owner`                             AS report_owner,
                    (
                        SELECT
                            ri.created_at
                        FROM
                            testrundb.report ri
                            JOIN testrundb.reportgrouparbitrary rgti
                                ON ( rgti.report_id = ri.id )
                        WHERE
                            rgti.arbitrary_id = rgt.arbitrary_id
                            AND $s_where
                        ORDER BY
                            rgti.primaryreport DESC,
                            rgti.report_id DESC
                        LIMIT
                            1
                    )                                       AS primary_date,
                    IFNULL( rgt.primaryreport, 0 )          AS primaryreport
                FROM
                    testrundb.report r
                    JOIN testrundb.suite s
                        ON ( s.id = r.suite_id )
                    JOIN testrundb.reportgrouparbitrary rgt
                        ON ( r.id = rgt.report_id )
                WHERE
                    $s_where
            )
            UNION
            (
                -- non related reports
                SELECT
                    r.id                                    AS report_id,
                    ''                                      AS grouping_id,
                    DATE_FORMAT( r.created_at, '%Y-%m-%d' ) AS report_date,
                    DATE_FORMAT( r.created_at, '%H:%i' )    AS report_time,
                    s.`name`                                AS suite_name,
                    r.machine_name,
                    r.peeraddr,
                    r.successgrade,
                    FLOOR( r.success_ratio )                AS success_ratio,
                    ''                                      AS report_owner,
                    r.created_at                            AS primary_date,
                    1                                       AS primaryreport
                FROM
                    testrundb.report r
                    JOIN testrundb.suite s
                        ON ( s.id = r.suite_id )
                    LEFT JOIN testrundb.reportgrouptestrun rgt
                        ON ( rgt.report_id = r.id )
                    LEFT JOIN testrundb.reportgrouparbitrary rga
                        ON ( rga.report_id = r.id )
                WHERE
                        rgt.report_id IS NULL
                    AND rga.report_id IS NULL
                    AND " . (join "\nAND ", grep { $_ } @h_where{qw/ suite_id machine_name successgrade success_ratio owner_null report_date /}) . "
            )
            ORDER BY
                primary_date DESC,
                grouping_id DESC,
                primaryreport DESC,
                report_id DESC
        ",
    };
}

1;