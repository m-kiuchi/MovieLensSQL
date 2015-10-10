#!/bin/bash

#SPARK_EXE=/home/demo/spark-1.4.1
if [ "${SPARK_EXE}" == "" ]; then
   echo "Please set environment variable SPARK_EXE"
   echo "ex). export SPARK_EXE=/home/kiuchi/spark-1.4.1"
   exit
fi

wget http://d12yw77jruda6f.cloudfront.net/ampcamp5-usb.zip
unzip ampcamp5-usb.zip

mv data/movielens/large/ratings.dat .
mv data/movielens/large/movies.dat .
mv data/movielens/medium/users.dat .

rm -rf ./data README.md ./SparkR ./sbt ./simple-app ./spark ./tachyon ./ampcamp5-usb.zip

./convert.pl

cd sql1 ; ${SPARK_EXE}/sbt/sbt assembly
cd ../sql2-1 ; ${SPARK_EXE}/sbt/sbt assembly
cd ../sql2-2 ; ${SPARK_EXE}/sbt/sbt assembly

cd ..

# Spark kickstart script generation
SPARKMEM=`free -g | head -2 | tail -1 | awk '{print $2}'`
SPARKMEM=`expr $SPARKMEM - 2`

cat >sql1.sh <<EOT
#!/bin/bash
${SPARK_EXE}/bin/spark-submit --class AggQuery --conf "spark.driver.memory=${SPARKMEM}g" ${PWD}/sql1/target/scala-2.11/sparksqldemo1-assembly-1.0.jar
EOT
chmod +x sql1.sh

cat >sql2-1.sh <<EOT
#!/bin/bash
${SPARK_EXE}/bin/spark-submit --class topTenWomen --conf "spark.driver.memory=${SPARKMEM}g" ${PWD}/sql2-1/target/scala-2.11/sparksqldemo2-1-assembly-1.0.jar
EOT
chmod +x sql2-1.sh

cat >sql2-2.sh <<EOT
#!/bin/bash
${SPARK_EXE}/bin/spark-submit --class topTenMoviename --conf "spark.driver.memory=${SPARKMEM}g" ${PWD}/sql2-2/target/scala-2.11/sparksqldemo2-2-assembly-1.0.jar
EOT
chmod +x sql2-2.sh

# Drill SQL Generation
cat > sql1.sql <<EOT
ALTER SYSTEM SET \`store.json.read_numbers_as_double\` = true;
SELECT COUNT(MOVIE) FROM dfs.\`${PWD}/ratings.json\` WHERE RATE > 3.0;
EOT

cat > sql2-1.sql <<EOT
ALTER SYSTEM SET \`store.json.read_numbers_as_double\` = true;
SELECT RATtbl.UID, COUNT(RATtbl.UID) as NUMEVALS FROM dfs.\`${PWD}/ratings.json\` as RATtbl JOIN dfs.\`${PWD}/users.json\` as USRtbl ON RATtbl.UID = USRtbl.UID WHERE USRtbl.GENDER = 'F' GROUP BY RATtbl.UID ORDER BY COUNT(RATtbl.UID) DESC LIMIT 10;
EOT

cat > sql2-2.sql <<EOT
ALTER SYSTEM SET \`store.json.read_numbers_as_double\` = true;
SELECT TMP2.MOVIE, TMP2.NUMRAT, TITLE FROM ( SELECT MOVIE, COUNT(MOVIE) as NUMRAT FROM dfs.\`${PWD}/ratings.json\` GROUP BY MOVIE) TMP2 JOIN dfs.\`${PWD}/movies.json\` AS MOVtbl ON TMP2.MOVIE = MOVtbl.MOVIE ORDER BY TMP2.NUMRAT DESC LIMIT 10;
EOT

