Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ED5C4CED1
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 08:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131EA2084D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 08:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbfJDIg7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 04:36:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43572 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731358AbfJDIg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:58 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3546F6D39FB9BE3089B;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:43 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 0/8] net/rtlwifi: remove some unused variables
Date:   Fri, 4 Oct 2019 16:43:47 +0800
Message-ID: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin (8):
  rtlwifi: rtl8821ae: Remove set but not used variables 'rtstatus','bd'
  rtlwifi: rtl8723ae: Remove set but not used variables
    'reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
  rtlwifi: rtl8192c: Remove set but not used variables
    'reg_ecc','reg_eac'
  rtlwifi: rtl8188ee: Remove set but not used variables
    'v3','rtstatus','reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
  rtlwifi: rtl8188ee: Remove set but not used variable 'h2c_parameter'
  rtlwifi: btcoex: Remove set but not used variable 'result'
  rtlwifi: btcoex: Remove set but not used variables
    'wifi_busy','bt_info_ext'
  rtlwifi: rtl8723: Remove set but not used variable 'own'

 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c     |  9 ---------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c     |  9 +--------
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c |  8 +-------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c    | 21 ++++-----------------
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c  |  8 ++------
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c    | 14 +++-----------
 .../wireless/realtek/rtlwifi/rtl8723com/fw_common.c |  4 ----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c    |  7 +------
 8 files changed, 12 insertions(+), 68 deletions(-)

--
2.7.4

