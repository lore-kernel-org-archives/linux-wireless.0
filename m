Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1IZH5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 03:57:09 -0400
Date: Mon, 26 Sep 2011 09:55:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Bernhard M. Wiedemann" <bernhardout@lsmod.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Ivo van Drn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: Bug in rt2800pci on an RT3090
Message-ID: <20110926075558.GA2273@redhat.com> (sfid-20110926_095713_267101_FEBBA119)
References: <4E7CEE67.2070906@lwfinger.net>
 <20110924163007.GA10001@redhat.com>
 <4E7E2738.6020208@lsmod.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E7E2738.6020208@lsmod.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

> the kernel config already has
> CONFIG_LOCKDEP_SUPPORT=y
> Is that what you meant? Does it need any extra to activate?

LOCKDEP_SUPPORT mean that LOCKDEP can be enabled on cpu architecture
for which kernel is build. To enable it you have to use "make menuconfig"
and mark up  "Kernel hacking ---> Lock debugging: prove locking correctness"
After that CONFIG_LOCKDEP=y should show up in .config.

> meanwhile I had a similar bug on rc6 hours after resuming.
>
> This time it had some additional soft lockup messages ontop. see
> http://www.zq1.de/~bernhard/temp/dmesg.bug

Again, lockdep should print more information and allow to debug
this easly.

Stanislaw
