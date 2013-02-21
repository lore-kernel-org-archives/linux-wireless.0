Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173015pub.verizon.net ([206.46.173.15]:55364 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3BUNfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 08:35:06 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173015.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIK00B20LM5R880@vms173015.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Thu, 21 Feb 2013 06:34:54 -0600 (CST)
From: "W. Trevor King" <wking@tremily.us>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <m@bues.ch>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	b43-dev@lists.infradead.org, "W. Trevor King" <wking@tremily.us>
Subject: [PATCH] b43: Fix 'me' -> 'be' typo in Kconfig
Date: Thu, 21 Feb 2013 07:34:42 -0500
Message-id: <81849f3444af632521ee18dfa3009b6f60efca86.1361449471.git.wking@tremily.us> (sfid-20130221_143512_030323_0FECF1E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "W. Trevor King" <wking@tremily.us>

Also add a missing 'the' before 'runtime performance'.

Signed-off-by: W. Trevor King <wking@tremily.us>
---
Based on wireless-testing's master-2013-02-19.

 drivers/net/wireless/b43/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 7a28d21..f259c49 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -166,8 +166,8 @@ config B43_DEBUG
 	  Broadcom 43xx debugging.
 
 	  This adds additional runtime sanity checks and statistics to the driver.
-	  These checks and statistics might me expensive and hurt runtime performance
-	  of your system.
+	  These checks and statistics might be expensive and hurt the runtime
+	  performance of your system.
 	  This also adds the b43 debugfs interface.
 
 	  Do not enable this, unless you are debugging the driver.
-- 
1.8.2.rc0.16.g20a599e

