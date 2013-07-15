Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3GOLqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:46:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 3.9 0/4] Enable 7000 device family on 3.9
Date: Mon, 15 Jul 2013 14:46:40 +0300
Message-Id: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_134651_294761_73BFED28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small patch series enables 7260 and 3160 devices on 3.9
kernel. Three patches are already in linux.git (3.11-rc1).
One patch is 3.9 specific and disables configuration that is not
supported in 3.9.

Dor Shaish (1):
  iwlwifi: mvm: don't use cts to self

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

