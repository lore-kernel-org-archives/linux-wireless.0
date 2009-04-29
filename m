Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61558 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZD2UA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 16:00:26 -0400
Received: by ewy24 with SMTP id 24so1484277ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 13:00:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Style fix for interval defines
Date: Wed, 29 Apr 2009 22:00:23 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904292200.23621.IvDoorn@gmail.com> (sfid-20090429_220030_249216_ECE7E57F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alban Browaeys <prahal@yahoo.com>

Extra parenthesis are not needed in these 2 cases,
all other defines in rt2x00 are done without parenthesis
so just fixup these 2 cases.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
This replaces the "rt2x00: Fix the interval for rfkill and link_tuner."
patch which was send recently. Code is the same, only changelog &
subject have been changed.
---

 drivers/net/wireless/rt2x00/rt2x00lib.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index aa284e4..747178c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -32,8 +32,8 @@
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
  */
-#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
-#define RFKILL_POLL_INTERVAL	( 1000 )
+#define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
+#define RFKILL_POLL_INTERVAL	1000
 
 /*
  * rt2x00_rate: Per rate device information
-- 
1.6.2.3

