package Im::Form::Widgets;
use strict;
use warnings;
use base 'HTML::Shakan::Widgets::Simple';
use HTML::Shakan::Utils;

sub widget_radio {
    my ($self, $form, $field) = @_;

    my $choices = delete $field->{choices};
    my $value   = $form->fillin_param($field->{name});

    my @r;
    while (my ($v, $l) = splice @$choices, 0, 2) {
        push @r, sprintf(
            q{<label class="blockLabels"><input type="radio" class="radioInput" name="%s" value="%s"%s /> %s</label>},
            encode_entities($field->name),
            encode_entities($v),
            ($value && $value eq $v ? ' checked="checked"' : ''),
            encode_entities($l),
        );
    }

    join "\n", @r;
}

sub widget_submit_button {
    my ($self, $form, $field) = @_;

    if (my $value = $form->fillin_param($field->{name})) {
        $field->value($value);
    }

    my $gen_attr = $self->can('SUPER::_attr');

    return '<button ' . $gen_attr->($field->attr) . '>'
           . encode_entities($field->label)
           . '</button>';
}

1;
