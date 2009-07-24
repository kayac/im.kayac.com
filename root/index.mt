? extends 'common/base'

? block content => sub {
<h2>Simple instant message (IM) posting API</h2>

<?= $self->render('about_' . $c->language) ?>

<p><?= x('Usage:') ?></p>

<pre><code>POST /api/post/<em>username</em> HTTP/1.0
Host: im.kayac.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 22

message=<em>Hello%20World!</em>
</code></pre>

<p><?= raw_string x('See <a href="[_1]">documentation</a> for more detail.', $c->uri_for('/#docs') ) ?></p>

<hr />

<script type="text/javascript"><!--
  var google_ad_client = "pub-5256446794843681";
  var google_alternate_color = "ffffff";
  var google_ad_width = 728;
  var google_ad_height = 90;
  var google_ad_format = "728x90_as";
  var google_ad_type = "text";
  var google_ad_channel = "";
  var google_color_border = "ffffff";
  var google_color_bg = "ffffff";
  var google_color_link = "55bb00";
  var google_color_text = "333333";
  var google_color_url = "55bb00";
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>

? unless ($c->user) {
<h2><?= x('Signup now!') ?></h2>

<form name="signup" action="<?= $c->uri_for('/signup/') ?>" method="post" class="uniForm">
  <fieldset class="blockLabels">
  <div class="ctrlHolder">
    <label for="username"><?= x('Username') ?></label>
    <input type="text" id="username" name="username" class="textInput" size="20" />
    <?# e('username') ?>
  </div>

  <div class="ctrlHolder">
    <label for="password"><?= x('Password') ?></label>
    <input type="password" id="password" name="password" class="textInput" size="20" />
    <?# e('password') ?>
  </div>
  </fieldset>

  <div class="buttonHolder">
    <button type="submit" class="submitButton"><?= x('Signup') ?></button>
  </div>

</form>

<script type="text/javascript" src="<?= $c->uri_for('/js/lib/uni-form.mochi.js') ?>"></script>
? } # end unless ($c->user)

<h2 id="docs"><?= x('API Documentation') ?></h2>

<?= $self->render('document_' . $c->language) ?>

? } # endblock content

