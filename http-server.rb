require 'nokogiri'
require 'open-uri'
require "cgi"

@httpserverUrl = 'http://127.0.0.1:8080'

toolong=[
    
]


def decode(path)
    xml = Nokogiri::HTML(URI.open(@httpserverUrl+path))
    puts CGI.unescape(path)
    if !Dir.exist?("./public"+CGI.unescape(path))
        Dir.mkdir("./public"+CGI.unescape(path))
    end
    
    File.write("./public#{CGI.unescape(path)}/index.html", xml.to_html)
    
    xml.xpath("//a[contains(@class,'icon-directory')]").each do |a|
        pathdeep = a["href"]
        if (!a["title"].include?(".."))
            decode(pathdeep)
        end
    end
end
decode("/")