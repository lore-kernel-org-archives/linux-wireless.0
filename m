Return-Path: <SRS0=16ef=XZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38630C4360C
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Sep 2019 08:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB932086A
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Sep 2019 08:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfI3IsO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 30 Sep 2019 04:48:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3185 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730110AbfI3IsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:13 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4299B58D45E983FB740F;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:47:58 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 0/6] rtlwifi: Remove a bunch of set but not used variables
Date:   Mon, 30 Sep 2019 16:54:46 +0800
Message-ID: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin (6):
  rtlwifi: Remove set but not used variable 'rtstate'
  rtlwifi: Remove set but not used variables 'dataempty','hoffset'
  rtlwifi: rtl8192ee: Remove set but not used variable 'err'
  rtlwifi: rtl8192ee: Remove set but not used variables
    'short_gi','buf_len'
  rtlwifi: rtl8192ee: Remove set but not used variables
    'reg_ecc','reg_eac'
  rtlwifi: rtl8723be: Remove set but not used variables
    'reg_ecc','reg_eac'

 drivers/net/wireless/realtek/rtlwifi/efuse.c         | 6 ++----
 drivers/net/wireless/realtek/rtlwifi/ps.c            | 3 ---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c  | 3 +--
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c | 8 ++------
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 8 --------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 8 ++------
 6 files changed, 7 insertions(+), 29 deletions(-)

--
2.7.4

