? extends 'common/base'

? block former_title => x('Signup') . ' - ';


? block content => sub {
<h2><?= x('Signup') ?></h2>

<p><?= x('Your account was successfully created.') ?></p>

<p><?= raw_string x('Plesae <a href="[_1]">set the IM information</a> from following link.', $c->uri_for('/setting/') ) ?></p>

<ul>
  <li><a href="<?= $c->uri_for('/setting/') ?>"><?= x('Setting') ?></a></li>
</ul>

? } # block content

