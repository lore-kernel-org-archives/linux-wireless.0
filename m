Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:16710 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:44 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:42 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 11/32] rt2800: initialize BBP_R70 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:34 +0200
Message-Id: <1368878635-4455-12-git-send-email-stf_xl@wp.pl> (sfid-20130518_142938_045317_40D412F6)
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
index d6b6f15..dd40c45 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3962,6 +3962,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 69, 0x12);
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3976,6 +3978,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 69, 0x12);
 		rt2800_bbp_write(rt2x00dev, 73, 0x10);
 	}
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -3985,6 +3989,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 69, 0x12);
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4004,6 +4010,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 76, 0x28);
 
 	rt2800_bbp_write(rt2x00dev, 77, 0x58);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4026,6 +4034,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 76, 0x28);
 
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4035,6 +4045,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 69, 0x12);
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4046,6 +4058,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 69, 0x12);
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4065,6 +4079,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 76, 0x28);
 
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
+
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4183,8 +4199,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
 	    rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
-- 
1.7.4.4

