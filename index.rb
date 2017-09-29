require 'fileutils'
require 'uri'
require 'ftools'

## 拼接html字符串
str = ''
str += '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta name="viewport" content="width=device-width"><meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/fancy-nginx.css" />
<title>Index of /nightly-firefox/</title>
</head><body><h1>Index of /nightly-firefox/</h1>
<table id="list" cellspacing="0" cellpadding="0.1em">
<colgroup><col width="55%"><col width="20%"><col width="25%"></colgroup>
<thead><tr><th><a href="http://localhost:7777/nightly-firefox/?C=N&amp;O=A">File Name</a>&nbsp;<a href="http://localhost:7777/nightly-firefox/?C=N&amp;O=D">&nbsp;↓&nbsp;</a></th><th><a href="http://localhost:7777/nightly-firefox/?C=S&amp;O=A">File Size</a>&nbsp;<a href="http://localhost:7777/nightly-firefox/?C=S&amp;O=D">&nbsp;↓&nbsp;</a></th><th><a href="http://localhost:7777/nightly-firefox/?C=M&amp;O=A">Date</a>&nbsp;<a href="http://localhost:7777/nightly-firefox/?C=M&amp;O=D">&nbsp;↓&nbsp;</a></th></tr></thead>
<tbody>'

  Dir.foreach('.'){|item|
    if /\d{14}/ =~ item.to_s
      str += '<tr>'
      file =  item.to_s + "/index.html"
      title =  ""
      if File.exist?(file)
        str  +=  '<td>'
        content = File.open(file).readlines
        content.each{|item|
          if /<title>([^<].+)<\/title>/ =~ item 
            title = $1
          end
        }
      end
    str += "<a href='./" + item.to_s + "/index.html'>" + title + "</a>"
    str += "<td>#{File.stat( file ).size}</td>"
    ctime = File::ctime(file).to_s.gsub(/\+\d{4}/, "").to_s.gsub(/(\d{2}:\d{2}):\d{2}/, '\1')
    str += "<td>#{ctime}</td>"
    str += '</td>'
    str += '</tr>'
    end
  }

str += '</tbody></table></body>
</html>'

## 把拼好的html字符串写入'index.html'
f = open('./index.html', 'w')
f.puts(str)

