Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:26791 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:49 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:48 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 14/32] rt2800: initialize BBP_R83 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:37 +0200
Message-Id: <1368878635-4455-15-git-send-email-stf_xl@wp.pl> (sfid-20130518_142937_504276_FE4A48D7)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 54042e4..5e3dfd4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3969,6 +3969,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 80, 0x08);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3989,6 +3991,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x37);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4006,6 +4010,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4034,6 +4040,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x7a);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4064,6 +4072,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x37);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4081,6 +4091,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4100,6 +4112,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4127,6 +4141,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+
+	rt2800_bbp_write(rt2x00dev, 83, 0x7a);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4245,13 +4261,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 83, 0x7a);
-	else
-		rt2800_bbp_write(rt2x00dev, 83, 0x6a);
-
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else if (rt2x00_rt(rt2x00dev, RT3290) ||
-- 
1.7.4.4

