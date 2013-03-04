Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41302 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDHOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 02:14:53 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] initvals: Remove unused ini files
Date: Mon,  4 Mar 2013 12:43:20 +0530
Message-Id: <1362381201-9704-1-git-send-email-sujith@msujith.org> (sfid-20130304_081456_218339_95EE7946)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/Makefile   | 3 ---
 tools/initvals/initvals.c | 7 -------
 2 files changed, 10 deletions(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index 065f410..2ba313d 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -9,18 +9,15 @@ ATHEROS_DEPS += \
 	ar5416.ini		\
 	ar5416_howl.ini		\
 	ar5416_sowl.ini		\
-	ar9280.ini		\
 	ar9280_merlin2.ini	\
 	ar9285.ini		\
 	ar9285_v1_2.ini		\
-	ar9287.ini		\
 	ar9287_1_1.ini		\
 	ar9271.ini		\
 	ar9300_osprey22.ini	\
 	ar9330_11.ini		\
 	ar9330_12.ini		\
 	ar9340.ini		\
-	ar9485.ini		\
 	ar955x.ini		\
 	ar9580.ini		\
 	ar9300_jupiter20.ini	\
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 9b23b8e..0f4c3f1 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -112,9 +112,6 @@ struct initval_family {
 
 #include "ar5416_sowl.ini"
 
-
-#include "ar9280.ini"
-
 #define ar9280Modes_merlin2					ar9280Modes_9280_2
 #define ar9280Common_merlin2					ar9280Common_9280_2
 #define ar9280Modes_fast_clock_merlin2				ar9280Modes_fast_clock_9280_2
@@ -148,10 +145,6 @@ struct initval_family {
 
 #include "ar9285_v1_2.ini"
 
-#define ar9287PciePhy_AWOW_kiwi1_0				ar9287PciePhy_AWOW_9287_1_0
-
-#include "ar9287.ini"
-
 #define ar9287Modes_kiwi1_1					ar9287Modes_9287_1_1
 #define ar9287Common_kiwi1_1					ar9287Common_9287_1_1
 #define ar9287Common_normal_cck_fir_coeff_kiwi1_1		ar9287Common_normal_cck_fir_coeff_9287_1_1
-- 
1.8.1.5

