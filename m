Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55080 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZE2TFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 15:05:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MA7O2-0008Er-Ei
	for linux-wireless@vger.kernel.org; Fri, 29 May 2009 19:05:02 +0000
Received: from 62.57.137.146.dyn.user.ono.com ([62.57.137.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 19:05:02 +0000
Received: from namaskar.youban by 62.57.137.146.dyn.user.ono.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 19:05:02 +0000
To: linux-wireless@vger.kernel.org
From: Namaskar <namaskar.youban@gmail.com>
Subject: BCM4303 (rev 02) Wireless doesn't detect APs
Date: Fri, 29 May 2009 18:42:34 +0000 (UTC)
Message-ID: <loom.20090529T182446-663@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I need help.

My BCM4303 (rev 02) does not work on Linux 2.6.28-11-generic #42-Ubuntu SMP Fri
Apr 17 01:57:59 UTC 2009 i686 GNU/Linux.

dmesg:
[ 2369.096080] b43legacy-phy0 debug: Radio initialized
[ 2369.096095] b43legacy-phy0 debug: Radio initialized
[ 2381.356506] input: b43legacy-phy0 as /devices/virtual/input/input11
[ 2381.508046] b43legacy-phy0: Loading firmware version 0x127, patch level 14
(2005-04-18 02:36:27)
[ 2381.608300] b43legacy-phy0 debug: Chip initialized
[ 2381.608606] b43legacy-phy0 debug: 30-bit DMA initialized
[ 2381.611262] Registered led device: b43legacy-phy0:tx
[ 2381.611298] Registered led device: b43legacy-phy0:rx
[ 2381.611336] Registered led device: b43legacy-phy0:radio
[ 2381.611377] b43legacy-phy0 debug: Wireless interface started
[ 2381.648162] b43legacy-phy0 debug: Adding Interface type 2
[ 2381.676543] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2382.368055] b43legacy-phy0: Radio hardware status changed to DISABLED

#iwlist wlan0 scan
wlan0     No scan results

	
I tried installing ndiswrapper but does not work either.

Does anyone know why?

Regards,

