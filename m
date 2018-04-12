Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23196 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752882AbeDLIJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:09:00 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 01/10] wil6210: disable tracing config option
Date: Thu, 12 Apr 2018 11:08:37 +0300
Message-Id: <1523520526-24997-2-git-send-email-merez@codeaurora.org> (sfid-20180412_100904_182184_B589622F)
In-Reply-To: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
References: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

Disable WIL6210_TRACING by default to avoid its performance overhead.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index b448926..3548e8d 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -33,7 +33,7 @@ config WIL6210_TRACING
 	bool "wil6210 tracing support"
 	depends on WIL6210
 	depends on EVENT_TRACING
-	default y
+	default n
 	---help---
 	  Say Y here to enable tracepoints for the wil6210 driver
 	  using the kernel tracing infrastructure.  Select this
-- 
1.9.1
