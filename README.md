/*-------------------------------------------------*/

/* Spark SQL Demo                                  */

/*  (performance comparison with Apache Drill)     */

/*       2015.9.15 at Tokyo Apache Drill Meetup    */

/*       Created by Mitsutoshi Kiuchi              */

/*                  <m-kiuchi@creationline.com>    */

/*-------------------------------------------------*/


1. Overview

This demo set is meant for demonstrate about query performance of Apache Spark and Apache Drill.

2. Prerequisite

- reasonable sufficient CPUs and memories(minimum 2core and 4GB)
- [recommend] CentOS 7
- Oracle JDK 1.8.0 update 60 or later
- Apache Spark 1.4.1 or later(already built and available)
- Apache Drill 1.1.0 or later(already built and available)
- demo data set ( written below )

3. Preconfifure - Demo data generation

simply execute bootstrap.sh
  [Note]
    "bootstrap.sh" gets sample data set and prepare it for your job, and build sample spark program.
    Finally, "bootstrap.sh" exports startup script which you can run it super-easy.

4. Execution

There is three type of SQL query.
1). "Aggregation Query": performs aggregate ratings and print the number.
2-1). "Join Query: type-1": list top 10 female user who is most frequently applied rate.
2-2). "Join Query: type-2": list top 10 movies which is most applied rate.

- for Spark
  run "sqlXXX.sh". XXX is 1, 2-1, 2-2.

- for Drill
  run "drill-embedded -f sqlXXX.sql". XXX is 1, 2-1, 2-2.


[Directory Structure]
.
├── README.txt
├── bootstrap.sh
├── convert.pl
├── sql1
│   ├── build
│   │   └── sbt-launch-0.13.9.jar
│   ├── build.sbt
│   ├── project
│   │   ├── build.properties
│   │   └── plugin.sbt
│   └── src
│       └── main
│           └── scala
│               └── AggQuery.scala
├── sql2-1
│   ├── build
│   │   └── sbt-launch-0.13.9.jar
│   ├── build.sbt
│   ├── project
│   │   ├── build.properties
│   │   └── plugin.sbt
│   └── src
│       └── main
│           └── scala
│               └── topTenWomen.scala
└── sql2-2
    ├── build
    │   └── sbt-launch-0.13.9.jar
    ├── build.sbt
    ├── project
    │   ├── build.properties
    │   └── plugin.sbt
    └── src
        └── main
            └── scala
                └── topTenMoviename.scala

