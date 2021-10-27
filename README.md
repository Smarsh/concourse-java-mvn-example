# kafka-streams-example
Basic Apache Kafka Streams Examples

## References
- https://docs.confluent.io/current/streams/developer-guide/index.html#

# *Start Confluent Stack*
```
$ curl -O http://packages.confluent.io/archive/5.2/confluent-5.2.1-2.12.zip
$ unzip confluent-5.2.1-2.12.zip
$ ./confluent-5.2.1/bin/confluent destroy
$ ./confluent-5.2.1/bin/confluent start
```

# BASIC-JAVA-STREAMS
## Project Setup
```
$ mvn -B archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=com.dh.app -DartifactId=kafka-streams-example
```
- https://docs.confluent.io/current/streams/developer-guide/write-streams.html
## To Run
```
kafka-consumer-example/basic-java-consumer $ mvn clean compile exec:java -Dexec.mainClass="com.dh.app.App"
```
TEST:25/10/2021 15:53:36

TEST:25/10/2021 15:54:39

TEST:25/10/2021 15:55:32

CONCOURSE_TEST:25/10/2021 15:58:45

CONCOURSE_TEST:25/10/2021 15:59:09

CONCOURSE_TEST:25-10-2021_15:59:33

CONCOURSE_TEST:25-10-2021 15:59:57

CONCOURSE_TEST-25-10-2021-16-01-33

CONCOURSE_TEST-25-10-2021--16-01-51

CONCOURSE_TEST-25-10-2021--16-34-34
\n CONCOURSE_TEST-26-10-2021--13-04-30
\n CONCOURSE_TEST-26-10-2021--14-02-33
\n CONCOURSE_TEST-26-10-2021--14-11-56
\n CONCOURSE_TEST-26-10-2021--14-20-47
\n CONCOURSE_TEST-26-10-2021--16-49-01
\n CONCOURSE_TEST-26-10-2021--16-54-06
\n CONCOURSE_TEST-27-10-2021--08-07-41
\n CONCOURSE_TEST-27-10-2021--08-55-57
\n CONCOURSE_TEST-27-10-2021--09-15-04
