Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53245 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2LBOxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 09:53:32 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] rt2x00: rt2800lib: fix indentation in rt2800_init_rfcsr
Date: Sun,  2 Dec 2012 15:53:29 +0100
Message-Id: <1354460009-28449-3-git-send-email-juhosg@openwrt.org> (sfid-20121202_155339_688565_8A7E5EB6)
In-Reply-To: <1354460009-28449-1-git-send-email-juhosg@openwrt.org>
References: <1354460009-28449-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  120 +++++++++++++++----------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3d7b74e..1cc6599 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4220,66 +4220,66 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
 		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
-	}	else if (rt2x00_rt(rt2x00dev, RT5392)) {
-			rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
-			rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
-			rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
-			rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
-			rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
-			rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
-			rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
-			rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
-			rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
-			rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
-			rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
-			rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
-			rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
-			rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
-			rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
-			rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
-			rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
-			rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
-			rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
-			rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
-			rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
-			rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
-			rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
-			rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
-			rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
-			rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
-			rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
-			rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
-			rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
-			rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
-			rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
-			rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
-			rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
-			rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
-			rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
-			rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
-			rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
-			rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
-			rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
-			rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
-			rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
-			rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
-			rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
-			rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
-			rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
-			rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
-			rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
-			rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
-			rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
-			rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
-			rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
-			rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+	} else if (rt2x00_rt(rt2x00dev, RT5392)) {
+		rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
+		rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
+		rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+		rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+		rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+		rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
+		rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
+		rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+		rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
+		rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+		rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
+		rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+		rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+		rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
+		rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
+		rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+		rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+		rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+		rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+		rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
+		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
+		rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
+		rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
+		rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
+		rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+		rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
+		rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
+		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+		rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
+		rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
+		rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
-- 
1.7.10

