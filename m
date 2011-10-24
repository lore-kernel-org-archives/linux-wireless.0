Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51255 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1JXJQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:16:52 -0400
Subject: [PATCH 1/9] ath6kl: remove unused A_CACHE_LINE_PAD
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:16:44 +0300
Message-ID: <20111024091644.5004.2767.stgit@localhost6.localdomain6> (sfid-20111024_111655_179521_A3E013E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index b92f0e5..d2efa19 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -23,8 +23,6 @@
 
 extern int ath6kl_printk(const char *level, const char *fmt, ...);
 
-#define A_CACHE_LINE_PAD            128
-
 /*
  * Reflects the version of binary interface exposed by ATH6KL target
  * firmware. Needs to be incremented by 1 for any change in the firmware

