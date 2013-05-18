Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:30239 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:48 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:46 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 13/32] rt2800: initialize BBP_R82 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:36 +0200
Message-Id: <1368878635-4455-14-git-send-email-stf_xl@wp.pl> (sfid-20130518_142939_028931_86463AA2)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 10050c3..54042e4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3967,6 +3967,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 	rt2800_bbp_write(rt2x00dev, 80, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3985,6 +3987,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 
 	rt2800_bbp_write(rt2x00dev, 81, 0x37);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4000,6 +4004,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4026,6 +4032,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 79, 0x18);
 	rt2800_bbp_write(rt2x00dev, 80, 0x09);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4054,6 +4062,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 	rt2800_bbp_write(rt2x00dev, 80, 0x08);
 	rt2800_bbp_write(rt2x00dev, 81, 0x37);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4069,6 +4079,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4086,6 +4098,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4111,6 +4125,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
+
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4229,7 +4245,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
-- 
1.7.4.4

