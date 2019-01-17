Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82126C43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 03:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD1020675
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 03:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfAQDHS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 22:07:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727185AbfAQDHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 22:07:18 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 77519385441B4406FEFC;
        Thu, 17 Jan 2019 11:07:16 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.408.0; Thu, 17 Jan 2019 11:07:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH v2] virt_wifi: remove duplicated include from virt_wifi.c
Date:   Thu, 17 Jan 2019 03:13:12 +0000
Message-ID: <1547694792-65647-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
References: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: fix prefix to 'virt_wifi:'
---
 drivers/net/wireless/virt_wifi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index 64b2186..245d4d0 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -14,11 +14,6 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 
-#include <net/cfg80211.h>
-#include <net/rtnetlink.h>
-#include <linux/etherdevice.h>
-#include <linux/module.h>
-
 static struct wiphy *common_wiphy;
 
 struct virt_wifi_wiphy_priv {



