Heres a small example to illustrate the issue being discussed at https://github.com/37signals/pow/issues/125

### Contents

This project is a vanilla Rails 4 project with:

 * A single model: `Theater`
 * A single attribute: `movie`
 * [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) installed, and a `MovieUploader` generated.
 * The `MovieUploader` mounted to the `Theater#movie` parameter.
 * A few dummy test files for uploading stored in `files`

### How to Reproduce

First get set up:

```
bundle install
rake db:migrate
powder link # or however you like to get pow set up
```

Then play with the below commands from the root of the project. Uploading the
smaller file works *most* of the time:

```
curl -v -F 'theater[movie]=@files/5MB.mov' 'http://pow-upload-eoferror-repro.dev/theaters'
* About to connect() to pow-upload-eoferror-repro.dev port 80 (#0)
*   Trying 127.0.0.1...
* connected
* Connected to pow-upload-eoferror-repro.dev (127.0.0.1) port 80 (#0)
> POST /theaters HTTP/1.1
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: pow-upload-eoferror-repro.dev
> Accept: */*
> Content-Length: 5243089
> Expect: 100-continue
> Content-Type: multipart/form-data; boundary=----------------------------aa91f916ce9b
>
< HTTP/1.1 100 Continue
< HTTP/1.1 200 OK
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-UA-Compatible: chrome=1
< Content-Type: application/json; charset=utf-8
< ETag: "25d9315f68d68172b5d4fd295cf50c02"
< Cache-Control: max-age=0, private, must-revalidate
< X-Request-Id: 8700d2d4-5272-4e20-b3c2-2077ac893c8c
< X-Runtime: 0.454037
< Connection: close
<
```

Uploading the larger file breaks *most* of the time:

```
 curl -v -F 'theater[movie]=@files/10MB.mov' 'http://pow-upload-eoferror-repro.dev/theaters'
* About to connect() to pow-upload-eoferror-repro.dev port 80 (#0)
*   Trying 127.0.0.1...
* connected
* Connected to pow-upload-eoferror-repro.dev (127.0.0.1) port 80 (#0)
> POST /theaters HTTP/1.1
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: pow-upload-eoferror-repro.dev
> Accept: */*
> Content-Length: 10485970
> Expect: 100-continue
> Content-Type: multipart/form-data; boundary=----------------------------e1c5a79caa11
>
< HTTP/1.1 100 Continue
< HTTP/1.1 500 Internal Server Error
< Content-Type: text/html; charset=utf8
< X-Pow-Template: error_starting_application
< Connection: keep-alive
< Transfer-Encoding: chunked
* HTTP error before end of send, stop sending
<
<!doctype html>
<html>
<head>
  (( ... snip ... ))
</head>
<body class="big">
  <div class="page">

  <h1 class="err">Error starting application</h1>
  <h2>Your Rack app raised an exception when Pow tried to run it.</h2>
  <section>
    <pre class="breakout small_text"><strong>EOFError: bad content body</strong>
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/multipart/parser.rb:74:in `block in fast_forward_to_first_boundary'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/multipart/parser.rb:72:in `loop'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/multipart/parser.rb:72:in `fast_forward_to_first_boundary'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/multipart/parser.rb:15:in `parse'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/multipart.rb:25:in `parse_multipart'
<a href="#" onclick="this.style.display='none',this.nextSibling.style.display='';return false">Show 19 more lines</a><div style="display: none">/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/request.rb:377:in `parse_multipart'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/request.rb:203:in `POST'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/methodoverride.rb:26:in `method_override'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/methodoverride.rb:14:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/runtime.rb:17:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/activesupport-4.0.0.rc1/lib/active_support/cache/strategy/local_cache.rb:83:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/rack-1.5.2/lib/rack/lock.rb:17:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/actionpack-4.0.0.rc1/lib/action_dispatch/middleware/static.rb:64:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/railties-4.0.0.rc1/lib/rails/engine.rb:511:in `call'
/opt/boxen/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/railties-4.0.0.rc1/lib/rails/application.rb:96:in `call'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:145:in `handle'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:99:in `rescue in block (2 levels) in start'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:96:in `block (2 levels) in start'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:86:in `each'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:86:in `block in start'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:66:in `loop'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:66:in `start'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/lib/nack/server.rb:13:in `run'
~/Library/Application Support/Pow/Versions/0.4.0/node_modules/nack/bin/nack_worker:4:in `&lt;main&gt;'</div></pre>
  </section>

  (( ... snip ... ))
</body>
</html>

* Closing connection #0
```
