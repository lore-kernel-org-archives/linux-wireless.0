Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41053 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYEJJNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 05:13:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: nphy.c remove duplicated include
Date: Sat, 10 May 2008 11:12:31 +0200
Cc: Huang Weiyi <weiyi.huang@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200805101112.31609.mb@bu3sch.de> (sfid-20080510_111316_025834_EB1D8EA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated include <linux/delay.h> in 
drivers/net/wireless/b43/nphy.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

--- a/drivers/net/wireless/b43/nphy.c   2008-05-10 08:46:36.000000000 +0800
+++ b/drivers/net/wireless/b43/nphy.c   2008-05-10 08:47:02.000000000 +0800
@@ -29,8 +29,6 @@
 #include "nphy.h"
 #include "tables_nphy.h"

-#include <linux/delay.h>
-

 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO


-- 
Greetings Michael.
