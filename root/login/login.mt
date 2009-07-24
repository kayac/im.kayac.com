? extends 'common/base'

? block former_title => x('Login') . ' - ';

? block content => sub {

<h2><?= x('Login') ?></h2>

<form name="login" method="post" class="uniForm">
  <fieldset class="blockLabels">
  <div class="ctrlHolder">
    <?= form->render('username') ?>
  </div>

  <div class="ctrlHolder">
    <?= form->render('password') ?>
  </div>
  </fieldset>

  <div class="buttonHolder">
? if (my $error = form->error_message_plain('login')) {
    <p class="error"><?= $error ?></p>
? }
    <button type="submit" class="submitButton"><?= x('Login') ?></button>
  </div>

</form>

<script type="text/javascript" src="<?= $c->uri_for('/js/lib/uni-form.mochi.js') ?>"></script>

? } # endblock content

