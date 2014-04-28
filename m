Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaD1PrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 11:47:00 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath9k_hw: update ar9300 initvals
Date: Mon, 28 Apr 2014 21:17:07 +0530
Message-ID: <1398700028-28410-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140428_174727_525627_2C1ECCC4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * rfsat gainchange hysteresis of rf_gain stuck with large
   interference present.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h | 2 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h | 2 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h | 2 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h     | 2 +-
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 0a6163e..c38399b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -410,7 +410,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x0d261800},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
 	{0x00009e54, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h b/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
index f76139b..2c42ff0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
@@ -592,7 +592,7 @@ static const u32 ar9331_1p1_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x0d261800},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
 	{0x00009fc0, 0x803e4788},
diff --git a/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
index 0ac8be9..2154efc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
@@ -231,7 +231,7 @@ static const u32 ar9331_1p2_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x0d261800},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
 	{0x00009fc0, 0x803e4788},
diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index a01f0ed..9cf7cca 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -318,7 +318,7 @@ static const u32 ar9340_1p0_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x0d261800},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
 	{0x00009e54, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index e6aec2c..a5ca652 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -90,7 +90,7 @@ static const u32 ar9580_1p0_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x0d261800},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
 	{0x00009e54, 0x00000000},
-- 
1.9.2

