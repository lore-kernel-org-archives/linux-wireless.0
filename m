Return-Path: <SRS0=qoP/=CT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A157C433E2
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 21:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 168A920829
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 21:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgIJVBe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:01:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbgIJOpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:30 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E8985BA4B5B5E162909A;
        Thu, 10 Sep 2020 21:52:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:52:22 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 0/3] rtlwifi: rtl8188ee: fix comparison pointer to bool warning
Date:   Thu, 10 Sep 2020 21:59:14 +0800
Message-ID: <20200910135917.143723-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zheng Bin (3):
  rtlwifi: rtl8188ee: fix comparison pointer to bool warning in phy.c
  rtlwifi: rtl8188ee: fix comparison pointer to bool warning in trx.c
  rtlwifi: rtl8188ee: fix comparison pointer to bool warning in hw.c

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c  | 12 ++++++------
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

--
2.26.0.106.g9fadedd

