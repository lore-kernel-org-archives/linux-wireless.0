Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53158 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941021AbdDTEfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:35:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 20 Apr 2017 07:35:17 +0300
Message-Id: <20170420043519.18615-1-luca@coelho.fi> (sfid-20170420_063640_641521_E3910773)
Subject: [PATCH 0/2] iwlwifi: a couple of fixes intended for 4.12
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

These two patches by Johannes fix one patch that was included in my
pull-req with tag iwlwifi-next-for-kalle-2017-04-13 (which you already pulled).

I'll include them in my new pull-req.

Cheers,
Luca.

Johannes Berg (2):
  iwlwifi: pcie: fix mutex leak in gen2 start
  iwlwifi: pcie: free context info in case of failures

 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c  | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.11.0
