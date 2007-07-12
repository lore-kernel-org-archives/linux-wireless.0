Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:43532 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757709AbXGLOfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 10:35:08 -0400
Message-ID: <46963C0F.3080104@lwfinger.net>
Date: Thu, 12 Jul 2007 09:34:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: bcm4301: A mac80211 driver using V3 firmware
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John and Michael,

I have good news regarding the driver mentioned in the subject. It is now working on my BCM4311 with 
performance that is nearly as good as for the softmac driver.

My approach has been to take the PHY and radio parts of the softmac driver and use them with as much 
of the bcm43xx-mac80211 code as possible. It therefore uses the SSB driver as part of the front end.

My plan is to clean up the code, check it with my BCM4306 and BCM4318 devices, and then make it 
available as a patch against the mainline source for more general testing. At the same time, I will 
publish the results of my performance testing of all 3 models. Once it is shown to be reliable, a 
decision can be made regarding its inclusion in mainline and if it should support B and G devices, 
or be restricted to B-only devices. The A-PHY code has been stripped out.

Larry

