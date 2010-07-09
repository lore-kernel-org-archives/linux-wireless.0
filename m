Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0GITXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 15:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/4]  iwlwifi update for 2.6.36
Date: Fri,  9 Jul 2010 12:24:36 -0700
Message-Id: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for 6050 series Gen2 devices
We also fix the bit mask of a FH register which will
cause timeout by polling unused bits
Newer version of uCode has advance error codes; we adding
support for these.

Emmanuel Grumbach (1):
  iwlagn: fix the bit mask of a FH register in stop Tx DMA flow

Jay Sternberg (1):
  iwlwifi: correct descriptions of advanced ucode errors

Shanyu Zhao (1):
  iwlwifi: enable 6050 series Gen2 devices

Wey-Yi Guy (1):
  iwlagn: more generic description for iwlagn devices

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Kconfig      |    9 ++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   38 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    7 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   44 +++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 ++
 drivers/net/wireless/iwlwifi/iwl-fh.h     |    7 +----
 8 files changed, 95 insertions(+), 16 deletions(-)

