? extends 'common/base'

? block former_title => x('Setting') . ' - ';

? block content => sub {

<h2><?= x('Setting') ?></h2>

<form name="activate" method="post" class="uniForm">
  <fieldset class="blockLabels"><legend><?= x('IM activation') ?></legend>
  <div class="ctrlHolder">
    <p><?= raw_string x('Add <em>api&#64;im.kayac.com</em> to your IM contact list and send it the following code:') ?></p>
    <?= form->render('code') ?>
  </div>
  </fieldset>

  <div class="buttonHolder">
    <?= raw_string form->input('reset') ?>
  </div>

</form>

<script type="text/javascript" src="<?= $c->uri_for('/js/lib/uni-form.mochi.js') ?>"></script>
<script type="text/javascript" src="<?= $c->uri_for('/js/setting.js') ?>"></script>

? } # endblock content

