jmeter压测，使用perfmon监控服务器cpu，内存资源。可以参考jmeter目录的配置。本次未提供jmeter压测报告。

ab压测报告

无skywalking链路id生成逻辑的基线压测：
ab -n 10000 -c 100 http://127.0.0.1/benchmark
======================================================================
======================================================================

zhangkeqi:~ zkq$ ab -n 10000 -c 100 http://127.0.0.1/benchmark
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        openresty/1.15.8.2
Server Hostname:        127.0.0.1
Server Port:            80

Document Path:          /benchmark
Document Length:        13 bytes

Concurrency Level:      100
Time taken for tests:   0.675 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1560000 bytes
HTML transferred:       130000 bytes
Requests per second:    14817.01 [#/sec] (mean)
Time per request:       6.749 [ms] (mean)
Time per request:       0.067 [ms] (mean, across all concurrent requests)
Transfer rate:          2257.28 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3   1.1      3      19
Processing:     1    3   1.3      3      19
Waiting:        0    3   1.2      3      19
Total:          4    7   1.7      6      22

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      7
  75%      7
  80%      7
  90%      8
  95%      8
  98%      9
  99%     11
 100%     22 (longest request)


 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

 带skywalking链路生成逻辑的压测
 ab -n 10000 -c 100 http://127.0.0.1/benchmark/skywalking
======================================================================
======================================================================

zhangkeqi:~ zkq$ ab -n 10000 -c 100 http://127.0.0.1/benchmark/skywalking
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        openresty/1.15.8.2
Server Hostname:        127.0.0.1
Server Port:            80

Document Path:          /benchmark/skywalking
Document Length:        13 bytes

Concurrency Level:      100
Time taken for tests:   0.687 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1560000 bytes
HTML transferred:       130000 bytes
Requests per second:    14559.58 [#/sec] (mean)
Time per request:       6.868 [ms] (mean)
Time per request:       0.069 [ms] (mean, across all concurrent requests)
Transfer rate:          2218.06 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3   0.5      3       5
Processing:     1    3   0.6      3      10
Waiting:        0    3   0.6      3      10
Total:          3    7   0.9      7      12

Percentage of the requests served within a certain time (ms)
  50%      7
  66%      7
  75%      7
  80%      8
  90%      8
  95%      8
  98%      9
  99%      9
 100%     12 (longest request)