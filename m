Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B69ECAAA1
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Sep 2022 09:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIKJCw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Sep 2022 05:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiIKJCr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Sep 2022 05:02:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19E399E3;
        Sun, 11 Sep 2022 02:02:44 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MQNt92T6HzNm7r;
        Sun, 11 Sep 2022 16:58:09 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 11 Sep 2022 17:02:41 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <gregory.greenman@intel.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <luciano.coelho@intel.com>,
        <johannes.berg@intel.com>, <cuigaosheng1@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 0/2] Remove unused declarations for iwlwifi
Date:   Sun, 11 Sep 2022 17:02:39 +0800
Message-ID: <20220911090241.3207201-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series contains a few cleanup patches, to remove unused
declarations which have been removed. Thanks!

Gaosheng Cui (2):
  iwlwifi: remove killer1650w_2ax_cfg and killer1650x_2ax_cfg
    declarations
  iwlwifi: remove unused no_sleep_autoadjust declaration

 drivers/net/wireless/intel/iwlwifi/dvm/power.h  | 2 --
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 --
 2 files changed, 4 deletions(-)

-- 
2.25.1

