Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60720 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753882AbeDZJMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 05:12:47 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath10k: fix spelling mistake: "servive" -> "service"
Date: Thu, 26 Apr 2018 10:12:44 +0100
Message-Id: <20180426091244.9160-1-colin.king@canonical.com> (sfid-20180426_111307_412918_7CB51956)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in ath10k_warn warning message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index df2e92a6c9bd..622e026ae940 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5280,7 +5280,7 @@ void ath10k_wmi_event_service_available(struct ath10k *ar, struct sk_buff *skb)
 
 	ret = ath10k_wmi_pull_svc_avail(ar, skb, &arg);
 	if (ret) {
-		ath10k_warn(ar, "failed to parse servive available event: %d\n",
+		ath10k_warn(ar, "failed to parse service available event: %d\n",
 			    ret);
 	}
 
-- 
2.17.0
