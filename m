Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0KWTE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 2.6.38
Date: Tue, 23 Nov 2010 10:58:51 -0800
Message-Id: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add advance power management support for newer devices
We also consider BT coex and shadow register as part of power management

Wey-Yi Guy (5):
  iwlagn: name change for BT config flag
  iwlwifi: add more power management flags
  iwlwifi: consider BT for power management
  iwlwifi: power management checking for shadow register
  iwlwifi: advance power management support

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-6000.c     |    9 +++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +
 drivers/net/wireless/iwlwifi/iwl-power.c    |   95 +++++++++++++++++++++++++--
 5 files changed, 117 insertions(+), 7 deletions(-)

