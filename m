Return-Path: <SRS0=lHvG=CH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9581DC433E2
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Aug 2020 11:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7995E207BB
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Aug 2020 11:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgH2Lzl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Aug 2020 07:55:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49752 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbgH2Lzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Aug 2020 07:55:39 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 92653D215371933788B4;
        Sat, 29 Aug 2020 19:55:18 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:55:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib80211: Remove unused macro DRV_NAME
Date:   Sat, 29 Aug 2020 19:55:06 +0800
Message-ID: <20200829115506.17828-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no caller in tree any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/wireless/lib80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index cc7b9fd5c166..d66a913027e0 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -26,8 +26,6 @@
 
 #include <net/lib80211.h>
 
-#define DRV_NAME        "lib80211"
-
 #define DRV_DESCRIPTION	"common routines for IEEE802.11 drivers"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
2.17.1


