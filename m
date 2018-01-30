Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56911 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753465AbeA3T1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 14:27:39 -0500
From: Colin King <colin.king@canonical.com>
To: Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wil6210: fix spelling mistake: "preperation"-> "preparation"
Date: Tue, 30 Jan 2018 19:27:37 +0000
Message-Id: <20180130192737.8986-1-colin.king@canonical.com> (sfid-20180130_202854_940763_6D481D89)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in debug error message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0c61a6c13991..04c8651274d9 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -715,7 +715,7 @@ static void wil_bl_prepare_halt(struct wil6210_priv *wil)
 		    offsetof(struct bl_dedicated_registers_v0,
 			     boot_loader_struct_version));
 	if (!tmp) {
-		wil_dbg_misc(wil, "old BL, skipping halt preperation\n");
+		wil_dbg_misc(wil, "old BL, skipping halt preparation\n");
 		return;
 	}
 
-- 
2.15.1
