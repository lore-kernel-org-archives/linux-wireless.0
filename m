Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate06.web.de ([217.72.192.247]:61164 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0DMTTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 15:19:15 -0400
Date: Tue, 13 Apr 2010 21:19:13 +0200 (CEST)
From: Ferdinand Rau <RauFerd@web.de>
To: linville@tuxdriver.com
Subject: Re: Bug report: Controller RESET (DMA error) long after connecting
Message-ID: <21256865.169208.1271186353636.JavaMail.fmail@mwmweb085>
References: <4375153.331710.1271156960878.JavaMail.fmail@mwmweb085>,
 <20100413131108.GB6331@tuxdriver.com>
MIME-Version: 1.0
In-Reply-To: <20100413131108.GB6331@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> The wireless connection works in principle (can connect to different networks, can ping, can browse), but at some point the following error happens and the connection is reset >> every few seconds afterwards rendering it unusable: >>> ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 >>> Controller RESET (DMA error) ... >> >> Similar to this thread (?): https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/006273.html > >Chances are that your device will work in PIO mode -- you can try >building a kernel w/ CONFIG_B43_FORCE_PIO. In 2.6.34, there is code >to switch automatically to PIO mode when such errors are observed. Thanks for your reply! If I find some spare time, I'll try it out, otherwise I'll just continue to use the wired connection on my desk and give it a new try as soon as kernel 2.6.34 is released (and packaged for debian for conveniance ;-). I'll report back in any case. Best regards from Germany, Ferdinand
___________________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de
