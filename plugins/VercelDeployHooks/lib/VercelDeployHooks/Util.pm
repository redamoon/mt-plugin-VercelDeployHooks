package VercelDeployHooks::Util;

use strict;
use warnings;

use MT;

use constant VercelDeployHooksUrl => 'https://api.vercel.com/v1/integrations/deploy/';
use HTTP::Request::Common;
use JSON;

use Exporter;
@VercelDeployHooks::Util::ISA = qw( Exporter );
use vars qw( @EXPORT_OK );
@EXPORT_OK = qw( plugin instance request doLog );

sub plugin {
    return MT->component('VercelDeployHooks');
}
sub instance { MT->instance->component('VercelDeployHooks'); }

sub request {
    my ($key, $blog_id, $save_name, $app, $error_name) = @_;
    require MT::Util::Log;
    MT::Util::Log->init();
    my $plugin = plugin();
    my $app_id = $plugin->get_config_value($key, 'blog:' . $blog_id);
    MT::Util::Log->info('VercelDeployHooks: no app_id') unless $app_id;
    return unless $app_id;

    # webhook url
    my $url = VercelDeployHooksUrl . $app_id;
    my $ua = MT->new_ua( { timeout => 10 } );
    return unless $ua;
    my $request = POST($url, Content_Type => 'application/json', Content => encode_json({}));
    my $response = $ua->request($request);

    if ($response->code == 201) {
        $app->add_return_arg($save_name => 1),
    } else {
        $app->add_return_arg($error_name => 1)
    };
    return unless $response->is_success();
    return 1;
}

sub doLog {
    my ($msg, $class) = @_;
    return unless defined($msg);

    require MT::Log;
    my $log = new MT::Log;
    $log->message($msg);
    $log->level(MT::Log::DEBUG());
    $log->class($class) if $class;
    $log->save or die $log->errstr;
}

1;
