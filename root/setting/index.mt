? extends 'common/base'

? block former_title => x('Setting') . ' - '

? block content => sub {

<h2><?= x('Setting') ?></h2>

<form name="setting" method="post" class="uniForm">
  <fieldset class="blockLabels">
  <div class="ctrlHolder">
    <?= form->render('im') ?>
  </div>

  <div class="ctrlHolder">
    <?= form->render('account') ?>
  </div>

  <div class="ctrlHolder">
    <?= form->render('auth') ?>
  </div>

  <div class="ctrlHolder passwordAuthHolder" id="password_auth_field" style="display:none">
    <?= form->render('password') ?>
  </div>

  <div class="ctrlHolder passwordAuthHolder" id="secret_auth_field" style="display:none">
    <?= form->render('secretkey') ?>
  </div>

  </fieldset>
  
  <div class="buttonHolder">
    <button type="submit" class="submitButton"><?= x('Change') ?></button>
  </div>

</form>

<script type="text/javascript" src="<?= $c->uri_for('/js/lib/uni-form.mochi.js') ?>"></script>
<script type="text/javascript" src="<?= $c->uri_for('/js/setting.js') ?>"></script>

? } # endblock content

