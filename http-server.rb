require 'nokogiri'
require 'open-uri'
require "cgi"

@httpserverUrl = 'http://127.0.0.1:8080'

toolong=[
    
]


def decode(path)
    xml = Nokogiri::HTML(URI.open(@httpserverUrl+path))
    if !Dir.exist?("./public"+CGI.unescape(path))
        Dir.mkdir("./public"+CGI.unescape(path))
    end
    
    File.write("./public#{CGI.unescape(path)}index.html", xml.to_html)
    
    xml.xpath("//tr").each do |tr|
        trxml = Nokogiri::HTML(tr.to_html)
        code = trxml.xpath("//td[@class='perms']/code").text
        if code.include?("(dr")
            pathdeep = trxml.xpath("//td[@class='display-name']/a")[0]["href"]
            if (!pathdeep.include?(".."))
                puts CGI.unescape(pathdeep)
                decode(pathdeep)
            end
        end
    end
end
decode("/")