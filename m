Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693D7C282CF
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4170F2084C
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfA2DWI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 22:22:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfA2DWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 22:22:08 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5D4DC4F2F1F9E46D153A;
        Tue, 29 Jan 2019 11:22:06 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 11:21:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 0/2] cleanup for iwlwifi
Date:   Tue, 29 Jan 2019 11:21:42 +0800
Message-ID: <20190129032144.18120-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

v2: Use struct_size in regd allocation

YueHaibing (2):
  iwlwifi: Use kmemdup instead of duplicating its function
  iwlwifi: Use struct_size() in kzalloc

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

-- 
2.7.4


