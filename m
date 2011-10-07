Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1214 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114Ab1JGQgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:36:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 13/14] ath9k_hw: Rename AR9480 -> AR9462 initvals
Date: Fri, 7 Oct 2011 22:07:14 +0530
Message-ID: <1318005434-998-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_183636_005860_E6F8EB03)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR946/8x chips are 2x2 Dual band with BT support. In order
to avoid misleading with other chips and to be in sync with
marketing team's term, AR9480 is renamed as AR9462.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: format patch -M
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 ++--
 ...ar9480_1p0_initvals.h => ar9462_1p0_initvals.h} |    0
 ...ar9480_2p0_initvals.h => ar9462_2p0_initvals.h} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{ar9480_1p0_initvals.h => ar9462_1p0_initvals.h} (100%)
 rename drivers/net/wireless/ath/ath9k/{ar9480_2p0_initvals.h => ar9462_2p0_initvals.h} (100%)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 901f417..6b2a4d0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -22,8 +22,8 @@
 #include "ar9330_1p1_initvals.h"
 #include "ar9330_1p2_initvals.h"
 #include "ar9580_1p0_initvals.h"
-#include "ar9480_1p0_initvals.h"
-#include "ar9480_2p0_initvals.h"
+#include "ar9462_1p0_initvals.h"
+#include "ar9462_2p0_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9480_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/ar9480_1p0_initvals.h
rename to drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
diff --git a/drivers/net/wireless/ath/ath9k/ar9480_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/ar9480_2p0_initvals.h
rename to drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
-- 
1.7.7

