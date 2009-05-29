Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:36519 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZE2TMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 15:12:33 -0400
Message-ID: <4A20339F.1060502@lwfinger.net>
Date: Fri, 29 May 2009 14:12:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Namaskar <namaskar.youban@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4303 (rev 02) Wireless doesn't detect APs
References: <loom.20090529T182446-663@post.gmane.org>
In-Reply-To: <loom.20090529T182446-663@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Namaskar wrote:
> Hi,
> 
> I need help.
> 
> My BCM4303 (rev 02) does not work on Linux 2.6.28-11-generic #42-Ubuntu SMP Fri
> Apr 17 01:57:59 UTC 2009 i686 GNU/Linux.
> 
> dmesg:
> [ 2369.096080] b43legacy-phy0 debug: Radio initialized
> [ 2369.096095] b43legacy-phy0 debug: Radio initialized
> [ 2381.356506] input: b43legacy-phy0 as /devices/virtual/input/input11
> [ 2381.508046] b43legacy-phy0: Loading firmware version 0x127, patch level 14
> (2005-04-18 02:36:27)
> [ 2381.608300] b43legacy-phy0 debug: Chip initialized
> [ 2381.608606] b43legacy-phy0 debug: 30-bit DMA initialized
> [ 2381.611262] Registered led device: b43legacy-phy0:tx
> [ 2381.611298] Registered led device: b43legacy-phy0:rx
> [ 2381.611336] Registered led device: b43legacy-phy0:radio
> [ 2381.611377] b43legacy-phy0 debug: Wireless interface started
> [ 2381.648162] b43legacy-phy0 debug: Adding Interface type 2
> [ 2381.676543] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 2382.368055] b43legacy-phy0: Radio hardware status changed to DISABLED

The last message says that your radio kill switch is off.

