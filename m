Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48332 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751874AbdLANFo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 08:05:44 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  1 Dec 2017 15:05:33 +0200
Message-Id: <20171201130535.27656-1-luca@coelho.fi> (sfid-20171201_140551_092971_0D4028B5)
Subject: [PATCH 0/2] iwlwifi: fixes intended for 4.15 2017-12-01
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third batch of fixes intended for 4.15.

These are the fixes:

* Add 2 new PCI IDs, one for 9000 and one for 22000;
* Fix a queue hang due during ROC;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Ihab Zhaika (1):
  iwlwifi: add new cards for 9260 and 22000 series

Johannes Berg (1):
  iwlwifi: mvm: flush queue before deleting ROC

 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 ++
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 24 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  2 ++
 3 files changed, 26 insertions(+), 2 deletions(-)

-- 
2.15.0
