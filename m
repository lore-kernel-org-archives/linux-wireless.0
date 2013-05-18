Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:60022 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:56 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:54 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 18/32] rt2800: initialize BBP_R91 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:41 +0200
Message-Id: <1368878635-4455-19-git-send-email-stf_xl@wp.pl> (sfid-20130518_142937_797522_36F01A75)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6d0e810..03145f7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3975,6 +3975,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -4004,6 +4006,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4027,6 +4031,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4061,6 +4067,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4099,6 +4107,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x38);
 
 	rt2800_bbp_write(rt2x00dev, 88, 0x90);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4122,6 +4132,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4147,6 +4159,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4183,6 +4197,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 88, 0x90);
+
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4301,8 +4317,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	rt2800_bbp_write(rt2x00dev, 91, 0x04);
-
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.4.4

