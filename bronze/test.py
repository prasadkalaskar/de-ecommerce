import os
from common.spark_utils import get_spark_session

# Check SPARK_HOME
print("SPARK_HOME =", os.environ.get("SPARK_HOME"))

# Start Spark session
spark = get_spark_session("ProfitSenseLocal")

# Check version
print("Spark Version:", spark.version)
