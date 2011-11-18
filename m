Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1KRBA2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 3.3
Date: Thu, 17 Nov 2011 16:05:08 -0800
Message-Id: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020033_230547_436049EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We adding few debug hooks and hope to catch more information when
encounter problems

Emmanuel Grumbach (4):
  iwlwifi: check the HW when a queue is stuck
  iwlwifi: improve the prints in the reclaim path
  iwlwifi: fix endianity issues in debug prints
  iwlwifi: tid_data is taken twice in iwl_trans_pcie_tx_agg_alloc

Wey-Yi Guy (1):
  iwlwifi: remove redundancy

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-io.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    4 ----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   12 ++++++++----
 5 files changed, 17 insertions(+), 13 deletions(-)

