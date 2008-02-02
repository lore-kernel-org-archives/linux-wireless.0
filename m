Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58818 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbYBBP1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 10:27:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Warning in DMA parse_cookie() -> Solution here
Date: Sat, 2 Feb 2008 16:26:03 +0100
MIME-Version: 1.0
Message-Id: <200802021626.03596.mb@bu3sch.de> (sfid-20080202_152759_936493_16AE761A)
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you get a warning in the DMA parse_cookie() function, it's
because you are using too new firmware.
Downgrade your firmware please.
Please read this page _carefully_ an do _exactly_ what it says:
http://www.linuxwireless.org/en/users/Drivers/b43#devicefirmware

There is no human readable message, because the patch for this got
lost in the 2.6.24 merge process. 2.6.24.1 will include a human readable
error message instead of this implicit failure message.

---

Hopefully this will help keeping the "bugreports" down, if one or two
people do actually read the list archives. :P

-- 
Greetings Michael.
