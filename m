Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0BETeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:34:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi updates for 2.6.34
Date: Fri,  5 Feb 2010 11:33:45 -0800
Message-Id: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two patches forming part of the 6x50 enabling effort. Also
included is the change to send a broadcast probe request when no directed
scan is requested, and directed probe requests otherwise

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Ben M Cahill (2):
  iwlwifi: Add chain noise scaling factor
  iwlwifi: Add chain_noise support for 6050

Samuel Ortiz (1):
  iwlwifi: Send broadcast probe request only when asked to

 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |   21 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c |   25 +++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c |   49 +++++++++++++++++++++----------
 6 files changed, 64 insertions(+), 36 deletions(-)

