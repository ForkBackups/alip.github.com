#!/usr/bin/env ruby
# coding: utf-8
# Copyright 2010, 2011 Ali Polatel <polatel@gmail.com>

%w{fileutils rubygems jekyll}.each {|m| require m}

def taglist_write(site, lang)
  File.open("#{lang}/tags/index.html", 'w+') do |f|
    f.puts <<-YAML
---
layout: tags
lang: #{lang}
---
YAML

    site.tags.sort_by {|s| s[1].length }.reverse.each do |tag, posts|
      posts &= site.categories['blog']
      posts &= site.categories[lang]
      next if posts.empty?

      f.puts <<-HEADER
{% assign myvar = "#{tag}" %}
{% include handleize.liquid %}
<h2 id="{{ myid }}">#{tag.capitalize}</h2>
  <table border="0" summary="posts tagged #{tag}">
HEADER

      posts.sort_by {|p| p.date }.reverse.each do |post|
        f.puts <<-POST
    <tr>
      <td class="date">#{post.date.strftime("%Y-%m-%d")} &raquo;</td>
      <td class="title">
        <a href="{{ site.url }}#{post.url}">#{post.data['title']}</a>
      </td>
    </tr>
POST
      end

      f.puts <<-FOOTER
  </table>
FOOTER
    end
  end
end

$stderr.puts "generating tag lists"

options = Jekyll.configuration({})
site = Jekyll::Site.new(options)
site.read_posts('')

FileUtils.mkdir_p 'en/tags'
taglist_write(site, 'en')

FileUtils.mkdir_p 'tr/tags'
taglist_write(site, 'tr')
