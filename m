Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37732 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbcF0NQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 09:16:51 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	akpm@linux-foundation.org, davem@davemloft.net,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v3] MAINTAINERS: remove unreachable people that have left Atmel
Date: Mon, 27 Jun 2016 14:16:13 +0100
Message-Id: <1467033373-20967-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160627_151714_468552_70CF166D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending an email regarding a patch to wilc1000, you get the following
automatic replies:
"Sung_hoon Cho is no longer with Atmel Corporation."
"Kang_hee Park is no longer with Atmel Corporation."
"Dong_ho Shin is no longer with Atmel Corporation."
"Bo_moon Kim is no longer with Atmel Corporation."
"Min_su Kim is no longer with Atmel Corporation."
"Jun_hyuk Lee is no longer with Atmel Corporation."

Removing this entry since none of the maintainers are reachable.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

This is unfortunate, but Greg recommended we drop the whole entry for now [0].

If nobody with more experience volunteers, I am happy to continue cleaning and
supporting this driver. This hardware is used by people in the Raspberry Pi
community, which is why I think it is worth it [1].

I am going to contact Atmel and see if they can provide me with a more complete
datasheet than they one in their website [2]. Since I would need this, plus the
hardware, before I can commit to anything.

Hopefully somebody from Atmel steps up since they are the experts.

Thanks,
Luis



[0] https://lkml.org/lkml/2016/6/26/202
[1] https://hackaday.io/project/9759-yet-another-pizero-wi-fi-hat
[2] http://www.atmel.com/Images/Atmel-42491-WILC1000B-MUT_Datasheet.pdf

 MAINTAINERS | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d059dd..8bd968f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11075,17 +11075,6 @@ M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
-STAGING - WILC1000 WIFI DRIVER
-M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Austin Shin <austin.shin@atmel.com>
-M:	Chris Park <chris.park@atmel.com>
-M:	Tony Cho <tony.cho@atmel.com>
-M:	Glen Lee <glen.lee@atmel.com>
-M:	Leo Kim <leo.kim@atmel.com>
-L:	linux-wireless@vger.kernel.org
-S:	Supported
-F:	drivers/staging/wilc1000/
-
 STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
 M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
-- 
2.6.4

