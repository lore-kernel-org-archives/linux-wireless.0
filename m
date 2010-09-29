Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0I2A4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 2.6.37
Date: Tue, 28 Sep 2010 17:56:53 -0700
Message-Id: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for 6050G2 series devices

Jay Sternberg (1):
  iwlwifi: define 100 devices

Shanyu Zhao (3):
  iwlwifi: add iwl_nic_ops structure to iwl_ops
  iwlagn: set CSR register for 6050g2 devices
  iwlwifi: send DC calib config to runtime ucode

Wey-Yi Guy (1):
  iwlagn: API v5 for 6050 series device

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c     |   73 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   61 +++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   29 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |   15 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 8 files changed, 176 insertions(+), 16 deletions(-)

