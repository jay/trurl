#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my @t = (
    "example.com|http://example.com/",
    "http://example.com|http://example.com/",
    "https://example.com|https://example.com/",
    "hp://example.com|hp://example.com/",
    "|",
    "ftp.example.com|ftp://ftp.example.com/",
    "https://example.com/../moo|https://example.com/moo",
    "https://example.com/.././moo|https://example.com/moo",
    "https://example.com/test/../moo|https://example.com/moo",
    "localhost --append path=moo|http://localhost/moo",
    "--set host=moo --set scheme=http|http://moo/",
    "-s host=moo -s scheme=http|http://moo/",
    "--set host=moo --set scheme=https --set port=999|https://moo:999/",
    "--set host=moo --set scheme=ftps --set path=/hello|ftps://moo/hello",
    "--url https://curl.se --set host=example.com|https://example.com/",
    "--set host=example.com --set scheme=ftp|ftp://example.com/",
    "--url https://curl.se/we/are.html --redirect here.html|https://curl.se/we/here.html",
    "--url https://curl.se/we/../are.html --set port=8080|https://curl.se:8080/are.html",
    "https://curl.se:22/ -s port=443|https://curl.se/",
    "https://curl.se:22/ -s port=443 --get {url}|https://curl.se/",
    "--url https://curl.se/we/are.html --get \"{path}\"|/we/are.html",
    "--url https://curl.se/we/are.html --get \"{port}\"|443",
    "--url https://curl.se/we/are.html --get \"{scheme}\"|https",
    "--url https://hello\@curl.se/we/are.html --get \"{user}\"|hello",
    "--url https://hello:secret\@curl.se/we/are.html --get \"{password}\"|secret",
    "--url \"imap://hello:secret;crazy\@curl.se/we/are.html\" --get \"{options}\"|crazy",
    "--url https://curl.se/we/are.html --get \"{host}\"|curl.se",
    "--url https://10.1/we/are.html --get \"{host}\"|10.0.0.1",
    "--url https://[fe80::0000:20c:29ff:fe9c:409b]:8080/we/are.html --get \"{host}\"|[fe80::20c:29ff:fe9c:409b]",
    "--url https://[fe80::0000:20c:29ff:fe9c:409b%eth0]:8080/we/are.html --get \"{zoneid}\"|eth0",
    "--url \"https://curl.se/we/are.html?user=many#more\" --get \"{query}\"|user=many",
    "--url \"https://curl.se/we/are.html?user=many#more\" --get \"{fragment}\"|more",
    "--url https://curl.se/we/are.html -g \"{port}\"|443",
    "--url https://curl.se/hello --append path=you|https://curl.se/hello/you",
    "--url \"https://curl.se?name=hello\" --append query=search=string|https://curl.se/?name=hello&search=string",
    "--url https://curl.se/hello --set user=:hej:|https://%3ahej%3a\@curl.se/hello",
    "--url https://curl.se/hello --set user=hej --set password=secret|https://hej:secret\@curl.se/hello",
    "--url https://curl.se/hello --set query:=user=me|https://curl.se/hello?user=me",
    "--url https://curl.se/hello --set fragment=\" hello\"|https://curl.se/hello#%20hello",
    "localhost --append query=hello=foo|http://localhost/?hello=foo",
    "\"https://example.com?search=hello&utm_source=tracker\" --trim query=\"utm_*\"|https://example.com/?search=hello",
    "\"https://example.com?search=hello&utm_source=tracker&more=data\" --trim query=\"utm_*\"|https://example.com/?search=hello&more=data",
    "\"https://example.com?search=hello&more=data\" --trim query=\"utm_*\"|https://example.com/?search=hello&more=data",
    "\"https://example.com?utm_source=tracker\" --trim query=\"utm_*\"|https://example.com/",
    "\"https://example.com?search=hello&utm_source=tracker&more=data\" --trim query=\"utm_source\"|https://example.com/?search=hello&more=data",
    "\"https://example.com?search=hello&utm_source=tracker&more=data\" --trim query=\"utm_source\" --trim query=more --trim query=search|https://example.com/",
    "--accept-space --url \"gopher://localhost/ with space\"|gopher://localhost/%20with%20space",
    "--accept-space --url \"https://localhost/?with space\"|https://localhost/?with+space",
    "https://daniel\@curl.se:22/ -s port= -s user=|https://curl.se/",
);

for my $c (@t) {
    my ($i, $o) = split(/\|/, $c);
    # A future version should also check stderr
    my @out = ($^O eq 'MSWin32')?`.\\trurl.exe $i 2>nul`:`./trurl $i 2>/dev/null`;
    my $result = join("", @out);
    chomp $result;
    is( $result, $o, "./trurl $i" );
}

done_testing();
