<?php //netteCache[01]000384a:2:{s:4:"time";s:21:"0.72132000 1363387374";s:9:"callbacks";a:2:{i:0;a:3:{i:0;a:2:{i:0;s:19:"Nette\Caching\Cache";i:1;s:9:"checkFile";}i:1;s:62:"I:\xampp\htdocs\GIT\platon\app\templates\Product\default.latte";i:2;i:1363387372;}i:1;a:3:{i:0;a:2:{i:0;s:19:"Nette\Caching\Cache";i:1;s:10:"checkConst";}i:1;s:25:"Nette\Framework::REVISION";i:2;s:30:"b7f6732 released on 2013-01-01";}}}?><?php

// source file: I:\xampp\htdocs\GIT\platon\app\templates\Product\default.latte

?><?php
// prolog Nette\Latte\Macros\CoreMacros
list($_l, $_g) = Nette\Latte\Macros\CoreMacros::initRuntime($template, 'wnkop9r7am')
;
// prolog Nette\Latte\Macros\UIMacros
//
// block head
//
if (!function_exists($_l->blocks['head'][] = '_lbd7eaf578de_head')) { function _lbd7eaf578de_head($_l, $_args) { extract($_args)
?><title>Kategorie</title><?php
}}

//
// block content
//
if (!function_exists($_l->blocks['content'][] = '_lb4f4797805f_content')) { function _lb4f4797805f_content($_l, $_args) { extract($_args)
?><div id="content">
    <div class="page-header">
  <h1>Google Nexus <small>Best products with Android ever</small></h1>
</div>
    <p class="text-left">Nexus 4 comes with the latest version of Google Now to bring you just the
        right information at just the right time. It shows you how much traffic
        to expect before you leave for work, or when the next train will arrive
        as you’re standing on the platform.
With the latest version, Google Now keeps you even more organized – get reminders
about upcoming flights, restaurant reservations, hotel confirmations and even
nearby photo opportunities – when and where you need them.</p>

<div class="row">
    <div class="span10">

<?php $_ctrl = $_control->getComponent("product"); if ($_ctrl instanceof Nette\Application\UI\IRenderable) $_ctrl->validateControl(); $_ctrl->render() ?>

    </div>

    <div class="span2">

        <ul class="nav nav-list">
            <li class="nav-header">Menu</li>
            <li class="active"><a href="#"><i class="icon-home"></i>Domů</a></li>
            <li><a href="#"><i class="icon-book"></i>Jak nakupovat</a></li>
            <li><a href="#"><i class="icon-heart"></i>Jak prodávat</a></li>
            <li><a href="#"><i class="icon-comment"></i>Jak cokoliv</a></li>
            <li class="divider"></li>
        </ul>

        <i class="icon-camera-retro icon-2x"></i><strong>Google Nexus</strong>
        <p>See source code of <a href="#template">this page template</a>, <a href="#layout">layout template</a> and
            <a href="#presenter">corresponding presenter</a>. And feel free to modify them!</p>
    </div>

</div>

</div>


<?php
}}

//
// end of blocks
//

// template extending and snippets support

$_l->extends = empty($template->_extended) && isset($_control) && $_control instanceof Nette\Application\UI\Presenter ? $_control->findLayoutTemplateFile() : NULL; $template->_extended = $_extended = TRUE;


if ($_l->extends) {
	ob_start();

} elseif (!empty($_control->snippetMode)) {
	return Nette\Latte\Macros\UIMacros::renderSnippets($_control, $_l, get_defined_vars());
}

//
// main template
//
if ($_l->extends) { ob_end_clean(); return Nette\Latte\Macros\CoreMacros::includeTemplate($_l->extends, get_defined_vars(), $template)->render(); }
call_user_func(reset($_l->blocks['head']), $_l, get_defined_vars())  ?>



<?php call_user_func(reset($_l->blocks['content']), $_l, get_defined_vars()) ; 