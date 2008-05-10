Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:34304 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYEJBJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 21:09:17 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2082497waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 18:09:17 -0700 (PDT)
Date: Sat, 10 May 2008 09:09:16 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mb@bu3sch.de, stefano.brivio@polimi.it
Subject: nphy.c: removed duplicated include
Cc: linux-wireless@vger.kernel.org
Message-Id: <20080510090722.244D.WEIYI.HUANG@gmail.com> (sfid-20080510_030921_562807_E988EF9C)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed duplicated include <linux/delay.h> in 
drivers/net/wireless/b43/nphy.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

--- a/drivers/net/wireless/b43/nphy.c   2008-05-10 08:46:36.000000000 +0800
+++ b/drivers/net/wireless/b43/nphy.c   2008-05-10 08:47:02.000000000 +0800
@@ -29,8 +29,6 @@
 #include "nphy.h"
 #include "tables_nphy.h"

-#include <linux/delay.h>
-

 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO

