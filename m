Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32794 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab1JNMxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:53:15 -0400
Received: by mail-yw0-f46.google.com with SMTP id 31so257185ywp.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:53:15 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 4/5] ath6kl: Add SDIO polling file into Makefile
Date: Fri, 14 Oct 2011 13:50:45 +0100
Message-Id: <1318596646-19495-5-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145323_994531_F0702C70)
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new file into Makefile

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 8f7a0d1..a8f4a55 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -32,6 +32,7 @@ ath6kl-y += main.o
 ath6kl-y += txrx.o
 ath6kl-y += wmi.o
 ath6kl-y += sdio.o
+ath6kl-$(CONFIG_ATH6KL_SDIO_POLL) += sdio_poll.o
 ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
 ccflags-y += -D__CHECK_ENDIAN__
-- 
1.7.4.1

