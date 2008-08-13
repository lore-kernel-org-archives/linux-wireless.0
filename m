Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9165 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYHMR3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 13:29:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: Ath5k missing led_classdev
Date: Wed, 13 Aug 2008 10:28:07 -0700
Message-ID: <BAD036B67C739F45BE062D0A03D19286036D35BB@orsmsx414.amr.corp.intel.com> (sfid-20080813_192914_685990_D27698FA)
From: "Lupusoru, Razvan A" <razvan.a.lupusoru@intel.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I compiled the package compat-wireless-2008-08-06 against 2.6.23 kernel.
After it is done compiling, I get some warnings. The relevant ones are:
WARNING: "led_classdev_register"
[/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
.ko] undefined!
WARNING: "led_classdev_unregister"
[/kernel2623/compat-wireless-2008-08-06/drivers/net/wireless/ath5k/ath5k
.ko] undefined!

What options in the kernel do I need to enable to get rid of these
warnings? I try to "modprobe ath5k" but it tells me it is missing those
so it cannot load.

In my .config file which I use to compile the kernel, I added:
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_IXP4XX=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y

Any ideas on what I am missing? Thanks.

Razvan A. Lupusoru
