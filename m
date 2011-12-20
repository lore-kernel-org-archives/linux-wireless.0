Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42291 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752022Ab1LTGJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 01:09:35 -0500
Date: Tue, 20 Dec 2011 11:39:29 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/2] mwl8k: Changing the driver version to 0.13
Message-ID: <20111220060916.GA4645@hertz.marvell.com> (sfid-20111220_070939_040787_5CCDED6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 241216c..83b2c19 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -28,7 +28,7 @@
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
-#define MWL8K_VERSION	"0.12"
+#define MWL8K_VERSION	"0.13"
 
 /* Module parameters */
 static unsigned ap_mode_default;
-- 
1.7.5.4

