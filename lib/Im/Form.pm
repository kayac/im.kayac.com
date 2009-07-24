package Im::Form;
use Ark 'Form';

use Im::Form::Widgets;

widgets 'Im::Form::Widgets';

sub message_format { q[<p class="formHint error">%s</p>] }

sub messages {
    return {
        not_null => x('please input [_1]'),
        int      => x('please input [_1] as integer'),
        ascii    => x('please input [_1] as ascii characters without space'),
    };
}

1;

