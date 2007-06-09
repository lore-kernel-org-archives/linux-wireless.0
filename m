Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:56093 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbXFIXGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 19:06:09 -0400
Received: from poczta.o2.pl (mx12.go2.pl [193.17.41.142])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id B8644230CC4
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2007 01:06:06 +0200 (CEST)
Received: from poczta.o2.pl (mx12 [127.0.0.1])
	by poczta.o2.pl (Postfix) with ESMTP id 826513E805C
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2007 01:00:02 +0200 (CEST)
Received: from Z-98C0293EFA704 (87-205-40-155.adsl.inetia.pl [87.205.40.155])
	by poczta.o2.pl (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2007 01:00:02 +0200 (CEST)
Date: Sun, 10 Jun 2007 00:59:57 +0200
From: zergavis <zergavis@o2.pl>
Reply-To: zergavis <zergavis@o2.pl>
Message-ID: <93387350.20070610005957@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi - not compatible with xorg 7.1 and i810 ??
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It's sounds silly, but new iwlwifi-0.0.25 crash down Xorg server. The
problem is intel i810 video driver.

In my toshiba A200 I've got intel945GM pci-e video card. It run
normal on xf-video-i810 driver (kernel support of 945 is experimental)
on archlinux.

When I install iwlwifi-0.0.25 (make, make install) for 4965AGN and
restart xserver, it crash...

Error log:

(EE) I810(0): V_BIOS Address 0x80 out of range
(EE) I810(0): VBE initialization failed.
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found

Now i just go to iwlwifi-0.0.25 and make uninstall. Server restart - and
xorg run perfectly, but iwl4965 is uninstalled :(

xorg.conf and other X configuration files or drivers are not changing during
this process. Only install and uninstall of iwlwifi-0.0.25...

Is there any known solution to fix this up?

regards,
pawel

