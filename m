Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:5149 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934283AbeEIKHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:07:13 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v3 1/8] wil6210: disable tracing config option
Date: Wed,  9 May 2018 13:06:52 +0300
Message-Id: <1525860419-6514-2-git-send-email-merez@codeaurora.org> (sfid-20180509_120720_841090_E34C4CF3)
In-Reply-To: <1525860419-6514-1-git-send-email-merez@codeaurora.org>
References: <1525860419-6514-1-git-send-email-merez@codeaurora.org>
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
