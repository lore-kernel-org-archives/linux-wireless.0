Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40436C47093
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 01:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A10361090
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 01:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhEaBtr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 May 2021 21:49:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2416 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhEaBto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 May 2021 21:49:44 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FtdPf0Rh6z67M9;
        Mon, 31 May 2021 09:44:22 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 09:48:02 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH] net: wireless: wext-compat: Fix spelling mistakes
Date:   Mon, 31 May 2021 10:01:42 +0800
Message-ID: <20210531020142.2920521-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix some spelling mistakes in comments:
explicitely  ==> explicitly

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index a8320dc59af7..7ef6fd26450c 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1183,7 +1183,7 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 		switch (wrq->flags & IW_POWER_MODE) {
 		case IW_POWER_ON:       /* If not specified */
 		case IW_POWER_MODE:     /* If set all mask */
-		case IW_POWER_ALL_R:    /* If explicitely state all */
+		case IW_POWER_ALL_R:    /* If explicitly state all */
 			ps = true;
 			break;
 		default:                /* Otherwise we ignore */
-- 
2.25.1

