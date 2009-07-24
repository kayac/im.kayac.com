use Test::Base;
use Im::Test;

use CGI::Simple;
use Im::Form::Setting;

plan 'no_plan';

filters {
    input => 'yaml',
};

run {
    my $block = shift;

    my $form = Im::Form::Setting->new(CGI::Simple->new($block->input));
    eval $block->test;
};

__DATA__

=== sinple error
--- input
im: ''
account: ''
--- test
ok $form->has_error, 'has_error ok';
is $form->error_message_plain('im'), 'Please select IM type', 'im error ok';
is $form->error_message_plain('account'), 'please input Account', 'account error ok';

=== sinple valid
--- input
im: 'jabber'
account: 'example@example.com'
auth: no
--- test
ok $form->submitted_and_valid, 'form is valid';

=== null password
--- input
im: 'jabber'
account: 'example@example.com'
auth: password
--- test
ok $form->has_error, 'has_error ok';
is $form->error_message_plain('password'), 'please input Password', 'password error ok';

=== not ascii password
--- input
im: 'jabber'
account: 'example@example.com'
auth: password
password: 日本語
--- test
ok $form->has_error, 'has_error ok';
is $form->error_message_plain('password'), 'please input Password as ascii characters without space', 'password error ok';

=== password ok
--- input
im: 'jabber'
account: 'example@example.com'
auth: password
password: password
--- test
ok $form->submitted_and_valid, 'form is valid ok';

=== null secret key
--- input
im: 'jabber'
account: 'example@example.com'
auth: secretkey
--- test
ok $form->has_error, 'has_error ok';
is $form->error_message_plain('secretkey'), 'please input Secret key', 'secretkey error ok';

=== not ascii secret key
--- input
im: 'jabber'
account: 'example@example.com'
auth: secretkey
secretkey: 日本語
--- test
ok $form->has_error, 'has_error ok';
is $form->error_message_plain('secretkey'), 'please input Secret key as ascii characters without space', 'secretkey error ok';

=== valid secret key
--- input
im: 'jabber'
account: 'example@example.com'
auth: secretkey
secretkey: secret_key
--- test
ok $form->submitted_and_valid, 'form is valid ok';
