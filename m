Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0KYBi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:26 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/12]  update for 2.6.38
Date: Wed, 24 Nov 2010 17:32:36 -0800
Message-Id: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We give the offical name to the latest Intel WiFI devices
We also fix number of P2P performance related issues

Johannes Berg (4):
  iwlagn: remove powersave warning
  iwlagn: fix station powersave accounting for aggregation
  iwlagn: advertise reliable TX status
  iwlwifi: use mac80211 AC defines

Wey-Yi Guy (8):
  iwlwifi: remove unused define
  iwlwifi: use antenna information in EEPROM
  iwlagn: Offical name for 6050g2 device
  iwlagn: Offical name for 6000g2a device
  iwlagn: Offical name for 6000g2b device
  iwlagn: Offical name for 100/130 device
  iwlagn: use different kill mask when SCO active
  iwlagn: minor change in bt coex normal LUT

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c       |   12 +----
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   20 ++-----
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   66 +++++++------------------
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   20 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |   34 ++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   45 +++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |   24 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    1 -
 11 files changed, 116 insertions(+), 112 deletions(-)

