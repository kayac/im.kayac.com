package Im;
use Ark;
use Im::Models;

our $VERSION = '0.01';

use_model 'Im::Models';

use_plugins qw{
    I18N

    Session
    Session::State::Cookie
    Session::Store::Model

    Authentication
    Authentication::Credential::Password
    Authentication::Store::DBIx::Class
};

config 'Plugin::Session::Store::Model' => {
    model => 'cache',
};

config 'Plugin::Authentication::Credential::Password' => {
    password_type      => 'hashed',
    digest_model       => 'sha1',
    password_pre_salt  => models('conf')->{password_pre_salt},
    password_post_salt => models('conf')->{password_post_salt},
};

config 'Plugin::Authentication::Store::DBIx::Class' => {
    model => 'schema',
};

config 'View::MT' => {
    macro => {
        html => sub {
            Text::MicroTemplate::escape_html(@_);
        },
        x => sub {
            Im->context->localize(@_),
        },
        copyright => sub {
            my $from = $_[0];
            my $yr   = (localtime)[5] + 1900;
            'Copyright &#169; ' . ($from < $yr ? "${from}-${yr}" : $from);
        },
        form => sub {
            Im->context->stash->{form};
        },
    },
};

#$SIG{__WARN__} = sub { Carp::confess(@_) };

1;
