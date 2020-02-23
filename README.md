# skywalking nginx插件
功能：扩展skywalking链路监控对nginx组件的支持。结合openresty，使用lua脚本实现。
说明：当前插件基于Skywalking5.x扩展，可做适当修改用于6.x。
待做：链路数据上报，节点拓扑渲染。

## 工程结构说明

- src目录
该目录下是所有lua脚本源码。
  - resty目录 - openresty相关的第三方公共组件
  - base目录 - lua工具组件
  - phase目录 - 按openresty处理http流程的关键字划分子目录，目前只有`init_worker`
  - config.lua - 配置skywalking基础信息  

- test目录

供压测使用
- jemeter

jemeter测试脚本接报告。待完善
- *.sh文件

用于开发环境启动openresty。

- nginx.conf - 用于*.sh脚本启动openresty。将当前开发路径指定为prefix，供开发调试。
- nginx-pro.conf - 使用默认方式启动openresty，用于发布前的测试。
- nginx-test.conf - 临时测试

## 开发说明
当前lua工程未使用luarocks管理源码，为区分lua插件源码结构与部署结构。所以需要手动创建如下的软链接：
```
cd /path/to/nginx-skywalking-plugin
ln -s src/ skywalking5
```

## 部署说明
### 方式一
- 1: 在openresty的lualib目录中创建创建`skywalking5`目录。
- 2: 将src目录下的所有内容拷贝至`skywalking5`目录。注意：`不包含src`目录自身。

### 方式二
- 1: 在任意位置创建一个openresty进程有权限访问的`skywalking5`目录。
- 2: 将src目录下的所有内容拷贝至`skywalking5`目录。注意：`不包含src`目录自身。
- 3: 在nginx.conf配置文件中添加如下指令（注意路径）：
```

http {
    ...
    ...
    ...
    
    # skywalking5 lua插件加载，注意路径不包含skywalking5目录自身
    lua_package_path "/{skywalking5目录的父目录}/?.lua;;";
    
    ...
    ...
    ...
} 
```

## nginx skywalking agent配置
所有配置集中在config.lua文件中。当前主要有两个配置：
- 1: skywalking服务端连接
```
_M.collector_server_url = "http://naming.xxxx.com:12801"

```

- 2: 配置skywalking识别agent的全局唯一标识
注意：该标识一定要全局唯一。
```
_M.application_code = "xxxxxx"

```

## 配置nginx.conf

### 1: init_worker_by_lua_file指令配置
通过init_worker_by_lua_file配置skywalking_init_worker.lua文件的决定路径
```
http {
    ...
    ...
    ...
    init_worker_by_lua_file {/local/path}/skywalking5/phase/init_worker/skywalking_init_worker.lua;
    ...
    ...
    ...
}

```

### 2：rewrite_by_lua_file指令配置
- 通过rewrite_by_lua_file指令在需要监控的反向代理location节点配置skywalking_upstream_rewrite.lua文件绝对路径
- 可配置块：http, server, location。配置作用域决定skywalking监控范围。如配置在server块，则server下的所有location的请求头都将添加skywalking的链路信息。
```
http {
    ...
    ...
    server {
        ...
        ...
        location /proxy/a-b-c {
            ...
            ...
            rewrite_by_lua_file {/local/path}/skywalking5/skywalking_upstream_rewrite.lua;
            ...
            ...
        }
        ...
        ...
    }
    ...
    ...
}

```

### 3：lua_shared_dict指令配置
- 在nginx.conf中的http块中添加以下配置
```
http {
    ...
    ...
    lua_shared_dict skywalking_dict 100k;
    ...
    ...
    
    server {
        ...
        ...
    }
    ...
    ...
}
```

### 4：access日志添加skywalking trace_id
- 通过set指令在需要监控的反向代理location节点配置`$skywalking_trace_id`变量
- 可配置块：server, location。
- 由于`skywalking_upstream_rewrite.lua`需要使用该变量，所以set配置的`$skywalking_trace_id`变量范围要与rewrite_by_lua_file指令配置的`skywalking_upstream_rewrite.lua`范围匹配，保证能访问到`$skywalking_trace_id`变量，否则会出错。

参考如下配置
- 4.1: 在server块添加`$skywalking_trace_id`变量
```
http {
    ...
    ...
    server {
        ...
        ...
        set $skywalking_trace_id '';
        location /proxy/a-b-c {
            ...
            ...
        }
        ...
        ...
    }
    ...
    ...
}
```


- 4.2: log_format配置
```
...
...

http {
    ...
    ...
    log_format  main  '$request_id - $skywalking_trace_id - $remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log logs/access.log main ;
    ...
    ...                      
}
...
...
```


### nginx.conf配置参考

- [nginx-pro.conf](http://gitlab.yqxiu.cn/eqxiu/skywalking/nginx-skywalking-plugin/blob/master/nginx-pro.conf)

说明：
- 配置后需要reload openresty或nginx。

## 检验
- reload或重启openresty，在error.log输出如下类似日志，则表明nginx信息注册skywalking成功。

error.log日志参考如下
```
...
...
2020/01/08 21:07:26 [alert] 14008#2393063: *12 [lua] app_and_service_register_client.lua:115: 获取skywalking instance注册信息: -2082:49267, context: ngx.timer
...
...
```

- 在access.log日志文件中如果按`log_format`配置的日志格式输出了skywalking_trace_id，则表明skywalking链路生成成功。

access.log日志参考如下：
```
...
...
dbdc8bb3794eb7d5533be9fa1e68e57b - 4926706865.8292.15784782680457 - 172.21.203.26 - - [08/Jan/2020:18:11:08 +0800] "GET /proxy/a-b-c HTTP/1.1" 200 52 "-" "PostmanRuntime/7.6.0" "-"
...
...
```

- error日志改为info，如有如下信息输出，则表明链路信息成功被设置到http request header头。

error.log日志参考如下：
```
...
...
2020/01/16 16:41:36 [notice] 58237#1355881: *231 [lua] skywalking_upstream_rewrite.lua:43: skywalking trace_id=2605884.5563.15791640967961,skywalking segment_id=2609667.3482.15791640967962, client: 127.0.0.1, server: localhost, request: "GET /benchmark/skywalking HTTP/1.0", host: "127.0.0.1"
2020/01/16 16:41:36 [notice] 58237#1355881: *231 [lua] skywalking_upstream_rewrite.lua:168: skywalking sw3_header=2609667.3482.15791640967962|0|26|26|#|#/benchmark/skywalking|#/benchmark/skywalking|2605884.5563.15791640967961, client: 127.0.0.1, server: localhost, request: "GET /benchmark/skywalking HTTP/1.0", host: "127.0.0.1"
...
...
```# nginx-skywalking-plugin
# nginx-skywalking-plugin
