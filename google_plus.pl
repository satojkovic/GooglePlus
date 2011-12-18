#!perl

use strict;
use warnings;

use Config::Pit;
use WWW::Mechanize;
use Web::Scraper;
use Encode;
use Growl::Any;
use AnyEvent;
use Data::Dumper;

## APIKey and UserID
my $config = pit_get("plus.google.com", require => {
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
my $agent = WWW::Mechanize->new( agent => "Mozilla/5.0 (X15; Linux x86_64) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.16 Safari/534.24" );
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

## timer watcher
my $t = AE::timer 0, 1800, sub {
    ## scraping
    my $scraper = scraper {
        process '//div[@class="Sq"]/div', 'list[]' => scraper { 
            process '//div[@class="jr"]/a/img', 'icon' => '@src'; 
            process '//div[@class="jr"]/div[@class="Ex"]/span[@class="eE"]/a', 'name' => 'TEXT'; 
            process '//div[@class="jr"]/div[@class="Ex"]/span[@class="mo fj"]/span[@class="Qh kn"]/a', 'time' => '@title';
            process '//div[@class="Bx"]//div[@class="vg"]', 'post' => 'TEXT'; 
        };
    };
    my $res = $scraper->scrape($agent->content);
    
    foreach my $item (@{$res->{list}}) {
        print encode_utf8("$item->{name} : $item->{post}\n\n");
    }
    
    ## notify by growl
    my $growl = Growl::Any->new(appname => "Growl a google+ stream",  events => ["gplus notification"]);
    
    foreach my $list (@{$res->{list}}) {
        $growl->notify(
            "gplus notification",
            $list->{name},
            $list->{post},
            $list->{icon},
        );
    }
};

AE::cv->recv;

