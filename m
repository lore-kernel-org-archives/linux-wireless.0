Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:48473 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab3ERMC6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:58 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:56 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 19/32] rt2800: initialize BBP_R92 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:42 +0200
Message-Id: <1368878635-4455-20-git-send-email-stf_xl@wp.pl> (sfid-20130518_142937_065490_526B3205)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 03145f7..3b3f66b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3977,6 +3977,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -4008,6 +4010,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4033,6 +4037,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4069,6 +4075,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x38);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4109,6 +4117,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 88, 0x90);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4134,6 +4144,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4161,6 +4173,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4199,6 +4213,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 88, 0x90);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4317,14 +4333,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT3352) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 92, 0x02);
-	else
-		rt2800_bbp_write(rt2x00dev, 92, 0x00);
-
 	if (rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 95, 0x9a);
 		rt2800_bbp_write(rt2x00dev, 98, 0x12);
-- 
1.7.4.4

