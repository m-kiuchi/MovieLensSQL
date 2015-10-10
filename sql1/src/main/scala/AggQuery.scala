import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._

object AggQuery {

  def main(args: Array[String]) {
    val blockSize = 1024 * 1024 * 64
    val conf = new SparkConf();
    conf.set("spark.app.name", "Scala Aggregation Query")
    val sc = new SparkContext(conf)
    sc.hadoopConfiguration.setInt("fs.local.block.size", blockSize)
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    //val rating = sqlContext.read.json("ratings.json")
    val rating = sqlContext.read.json("ratings.json")
    rating.registerTempTable("ratings")
    val res = rating.filter("RATE > 3.0")
    val cnt = res.count()
    println("Result>>> ", cnt)
  }
}
