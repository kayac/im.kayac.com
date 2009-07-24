? extends 'common/base';

? block former_title => x('Signup') . ' - ';

? block content => sub {
<h2><?= x('Signup') ?></h2>

<form name="signup" method="post" class="uniForm">
  <fieldset class="blockLabels">
  <div class="ctrlHolder">
    <?= form->render('username') ?>
  </div>

  <div class="ctrlHolder">
    <?= form->render('password') ?>
  </div>
  </fieldset>

  <div class="buttonHolder">
    <button type="submit" class="submitButton"><?= x('Signup') ?></button>
? if (my $err = form->error_message('login')) {
    <?= $err ?>
? }
  </div>

</form>

<script type="text/javascript" src="<?= $c->uri_for('/js/lib/uni-form.mochi.js') ?>"></script>

? } # endblock content

