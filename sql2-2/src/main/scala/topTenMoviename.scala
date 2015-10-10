import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.sql.functions._

object topTenMoviename {

  def main(args: Array[String]) {
    val blockSize = 1024 * 1024 * 64
    val conf = new SparkConf();
    conf.set("spark.app.name", "Scala Aggregation Query")
    val sc = new SparkContext(conf)
    sc.hadoopConfiguration.setInt("fs.local.block.size", blockSize)
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    val rating = sqlContext.read.json("ratings.json").withColumnRenamed("UID", "RUID")
    val movie = sqlContext.read.json("movies.json").withColumnRenamed("MOVIE", "MMOVIE")
    val con = rating.groupBy("MOVIE").count().sort(desc("count"))
    val con2 = con.take(10).foreach(x => {
      val movno = x(0)
      val movtitle = movie.where(movie("MMOVIE") === movno).select("TITLE").take(1)(0)
      println("RESULT>>> MOVID: ", movno, " NUMRAT: ", x(1), " TITLE: ", movtitle)
    })
  }
}
