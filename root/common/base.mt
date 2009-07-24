<?= raw_string qq!<\?xml version="1.0" encoding="utf-8"?\>! ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
<head>
<title><?
          block former_title => '';
          block title        => 'im.kayac.com';
          block latter_title => '';
?></title>
<link rel="stylesheet" type="text/css" href="<?= $c->uri_for('/css/default.css') ?>" />
<script type="text/javascript" src="<?= $c->uri_for('/js/lib/MochiKit.js') ?>"></script>
</head>
<body>
<div id="container">

<ul id="menu">
? if ($c->user) {
  <li class="user_info"><?= x('logined as [_1]', $c->user->obj->username) ?></li>
  <li><?= raw_string x('<a href="[_1]">Setting</a>', $c->uri_for('/setting/')) ?></li>
  <li><?= raw_string x('<a href="[_1]">Logout</a>', $c->uri_for('/logout/')) ?></li>
? } else {
  <li><?= raw_string x('<a href="[_1]">Signup</a>', $c->uri_for('/signup/')) ?></li>
  <li><?= raw_string x('<a href="[_1]">Login</a>', $c->uri_for('/login/')) ?></li>
? }
</ul>

<h1><a href="<?= $c->uri_for('/') ?>"><? block 'title' ?></a></h1>

<? block content => '' ?>

<div id="footer">
  <p>
? if ($c->language eq 'ja') {
    日本語 | <a href="<?= $c->uri_for('/en', $c->req->uri->path_query) ?>">English</a>
? } else {
    <a href="<?= $c->uri_for('/ja', $c->req->uri->path_query) ?>">日本語</a> | English
? }
  </p>
  <p><?= raw_string copyright(2007) ?> <a href="http://www.kayac.com/">KAYAC Inc</a>, <a href="http://bm11.kayac.com/">BM11 Project</a>. All Rights Reserved.</p>
</div>

</div>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
<script type="text/javascript">
var _uacct = "UA-53432-33";
urchinTracker();
</script>

<img src="http://log.kayac.com/cl/?rs=i&amp;cm=bm1100019&amp;ln=1" width="1" height="1">

</body>
</html>
