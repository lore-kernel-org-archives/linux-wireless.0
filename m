Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56061 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcL2UOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 15:14:50 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>, Shahar Patury <shaharp@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: fix spelling mistake in wl1271_warning
Date: Thu, 29 Dec 2016 20:14:00 +0000
Message-Id: <20161229201400.26830-1-colin.king@canonical.com> (sfid-20161229_211703_537612_CD48519A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake of function name in wl1271_warning,
should be dynamic_ps_timeout instead of dyanmic_ps_timeout.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 7f672f6..58e148d 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -281,7 +281,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 	}
 
 	if (value < 1 || value > 65535) {
-		wl1271_warning("dyanmic_ps_timeout is not in valid range");
+		wl1271_warning("dynamic_ps_timeout is not in valid range");
 		return -ERANGE;
 	}
 
-- 
2.10.2
