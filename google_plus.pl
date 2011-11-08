#!perl

use strict;
use warnings;

use Config::Pit;
use WebService::Simple;
use WWW::Mechanize;
use Web::Scraper;
use Encode;
use YAML;

## APIKey and UserID
my $config = pit_get("plus.google.com", require=>{
    "APIKey" => "your API key",
    "UserID" => "your user ID",
    "Mail" => "your mailaddress",
    "Password" => "your password"
                     });

my $api_key = $config->{APIKey};
my $user_id = $config->{UserID};
my $mail = $config->{Mail};
my $password = $config->{Password};

## login
my $agent = WWW::Mechanize->new;
$agent->get('https://plus.google.com');
$agent->follow_link( 
    url_abs_regex => qr{^https://accounts\.google\.com/ServiceLogin},
    );
$agent->submit_form(
    with_fields => {
        Email => $mail,
        Passwd => $password,
    },
    );
$agent->get('https://plus.google.com');

print $agent->content;
