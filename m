Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47577 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1AET1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:27:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: correct MODULE_PARM_DESC parameters for force_new_ani
Date: Wed,  5 Jan 2011 14:15:26 -0500
Message-Id: <1294254926-8275-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index fdb5a83..f8a7771 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -22,7 +22,7 @@
 
 int modparam_force_new_ani;
 module_param_named(force_new_ani, modparam_force_new_ani, int, 0444);
-MODULE_PARM_DESC(nohwcrypt, "Force new ANI for AR5008, AR9001, AR9002");
+MODULE_PARM_DESC(force_new_ani, "Force new ANI for AR5008, AR9001, AR9002");
 
 /* General hardware code for the A5008/AR9001/AR9002 hadware families */
 
-- 
1.7.3.4

