import os
from pyspark.sql import SparkSession


def get_spark_session(app_name="Delta Lake Session"):
    return (
        SparkSession.builder
        .appName(app_name)
        .config("spark.jars.packages", "io.delta:delta-core_2.12:2.4.0")
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
        .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
        .getOrCreate()
    )


def view_silver_orderitems():
    spark = get_spark_session()

    # Path to Silver Delta folder
    silver_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/silver/orders"))

    # Read Delta table
    df = spark.read.format("delta").load(silver_path)

    # Show records and schema
    df.show(truncate=False)



if __name__ == "__main__":
    view_silver_orderitems()
