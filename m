Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44495 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbeC2QxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 12:53:06 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath6kl: fix spelling mistake: "chache" -> "cache"
Date: Thu, 29 Mar 2018 17:53:04 +0100
Message-Id: <20180329165304.26504-1-colin.king@canonical.com> (sfid-20180329_185322_495613_A4BEF909)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 0f965e9f38a4..4e94b22eaada 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -645,7 +645,7 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
 			 "CRC Err", tgt_stats->rx_crc_err);
 	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
-			 "Key chache miss", tgt_stats->rx_key_cache_miss);
+			 "Key cache miss", tgt_stats->rx_key_cache_miss);
 	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
 			 "Decrypt Err", tgt_stats->rx_decrypt_err);
 	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
-- 
2.15.1
