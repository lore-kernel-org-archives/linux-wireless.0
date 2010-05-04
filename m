Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out110.alice.it ([85.37.17.110]:2763 "EHLO
	smtp-out110.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab0EDPYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 11:24:23 -0400
Subject: Re: wl1251_sdio PSM
From: gnutoo <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20100427T143119-272@post.gmane.org>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
	 <1272235632.2349.28.camel@gnutoo-desktop>
	 <1272285416.2364.1.camel@gnutoo-desktop>
	 <loom.20100427T143119-272@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 17:24:15 +0200
Message-ID: <1272986655.2486.42.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> You need a few more patches for PS to work (on top of current compat-wireless):
> http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-kernel.git;a=commitdiff;h=8eb97a1915ae2ab0a19cc6eef1a2753b9514017d
> http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-wifi.git;a=commitdiff;h=d16ed8871faa892f5fd4e8161412051ee11c5ecb
> 
> I'm working on mainline mergeable versions of those..
2 things:
*I rebased the patches against lastest compat wireless but I don't know
where to send them...
Basically or they apply or they are already in compat-wireless(verified)
here are the one which applies:
0007-wl1251-read-default-MAC-address-from-EEPROM-when-ava.patch
0008-wl1251-register-platform_device-to-pass-board-data.patch
0009-wl1251-add-support-for-dedicated-IRQ-line.patch
0010-wl1251-use-sdio_readb_ext-for-ELP-to-work.patch
0011-wl1251-add-reset-handling.patch
0013-wl1251-prevent-scan-when-connected.patch

against compat-wireless-2010-04-26

By the way we can't make ad-hoc work,Is ad-hoc supported by the driver?

Denis.


