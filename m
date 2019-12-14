Return-Path: <SRS0=C7Rt=2E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1347FC43603
	for <linux-wireless@archiver.kernel.org>; Sat, 14 Dec 2019 10:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F1724125
	for <linux-wireless@archiver.kernel.org>; Sat, 14 Dec 2019 10:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfLNKPZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 14 Dec 2019 05:15:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfLNKPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Dec 2019 05:15:25 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 41337527F6D14078B992;
        Sat, 14 Dec 2019 18:15:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 14 Dec 2019
 18:15:12 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] ath11k: Remove unneeded semicolon
Date:   Sat, 14 Dec 2019 18:22:34 +0800
Message-ID: <1576318954-40658-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/ath/ath11k/wmi.h:2570:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 4a518d4..22c887a 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2567,7 +2567,7 @@ static inline const char *ath11k_wmi_phymode_str(enum wmi_phy_mode mode)
 		/* no default handler to allow compiler to check that the
 		 * enum is fully handled
 		 */
-	};
+	}

 	return "<unknown>";
 }
--
2.7.4

