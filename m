Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab3GOLTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:19:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.10 0/3] Enable 7000 device family on 3.10
Date: Mon, 15 Jul 2013 14:19:13 +0300
Message-Id: <1373887153-2748-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_131938_562822_8CDAA4CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small patch series enables 7260 and 3160 devices on 3.10
kernel. Three patches are already in linux.git (3.11-rc1).
One patch is 3.10 specific and disables configuration that is not
supported in 3.10.

Emmanuel Grumbach (1):
  iwlwifi: mvm: support BSS only

Johannes Berg (2):
  iwlwifi: mvm: adjust firmware D3 configuration API
  iwlwifi: bump required firmware API version for 3160/7260

 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h |    4 +++-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |   24 +-----------------------
 drivers/net/wireless/iwlwifi/pcie/7000.c     |   12 ++++++------
 4 files changed, 12 insertions(+), 32 deletions(-)

-- 
1.7.10.4

