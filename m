Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1LTSqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:46:25 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 3/6] ath9k_hw: fix sparse warnings on ar9003_rtt.c
Date: Tue, 20 Dec 2011 10:46:08 -0800
Message-ID: <1324406771-7100-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194629_131166_F879B017)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This fixes these sparse warnings:

  CHECK   drivers/net/wireless/ath/ath9k/ar9003_rtt.c
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:36:6: warning: symbol 'ar9003_hw_rtt_enable' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:41:6: warning: symbol 'ar9003_hw_rtt_disable' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:46:6: warning: symbol 'ar9003_hw_rtt_set_mask' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:52:6: warning: symbol 'ar9003_hw_rtt_force_restore' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:102:6: warning: symbol 'ar9003_hw_rtt_load_hist' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:135:6: warning: symbol 'ar9003_hw_rtt_fill_hist' was not declared. Should it be static?
drivers/net/wireless/ath/ath9k/ar9003_rtt.c:143:6: warning: symbol 'ar9003_hw_rtt_clear_hist' was not declared. Should it be stati

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
index 48803ee..458bedf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -16,6 +16,7 @@
 
 #include "hw.h"
 #include "ar9003_phy.h"
+#include "ar9003_rtt.h"
 
 #define RTT_RESTORE_TIMEOUT          1000
 #define RTT_ACCESS_TIMEOUT           100
-- 
1.7.4.15.g7811d

