import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.sql.functions._

object topTenWomen {

  def main(args: Array[String]) {
    val blockSize = 1024 * 1024 * 64
    val conf = new SparkConf();
    conf.set("spark.app.name", "Scala Aggregation Query")
    val sc = new SparkContext(conf)
    sc.hadoopConfiguration.setInt("fs.local.block.size", blockSize)
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    val rating = sqlContext.read.json("ratings.json").withColumnRenamed("UID", "RUID")
    val user = sqlContext.read.json("users.json").withColumnRenamed("UID", "UUID")
    val con = rating.join(user, rating("RUID") === user("UUID")).filter("GENDER LIKE 'F'").groupBy("RUID").count().sort(desc("count"))
    con.show(10)
  }
}
