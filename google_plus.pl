#!perl

use strict;
use warnings;

use Config::Pit;
use WebService::Simple;

## APIKey and UserID
my $config = pit_get("plus.google.com", require=>{
    "APIKey" => "your API key",
    "UserID" => "your user ID"
                     });

my $api_key = $config->{APIKey};
my $user_id = $config->{UserID};

## API access
my $agent = WebService::Simple->new(
    base_url => "https://www.googleapis.com/plus/v1/people/$user_id/activities/public",
    param => { alt=>'json', pp => 1, key => $api_key },
    reponse_parse => 'JSON',
    );

my $res = $agent->get();
print $res->parse_response;

