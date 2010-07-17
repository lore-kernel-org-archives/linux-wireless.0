Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab0GQOxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 10:53:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/3] iwlwifi update for 2.6.36
Date: Sat, 17 Jul 2010 07:55:13 -0700
Message-Id: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add stuck tx queue recovery function for 4965 device
We also include more statistics counters in debugfs to help debugging

Wey-Yi Guy (3):
  iwlwifi: additional statistic debug counter
  iwlwifi: more statistics counter for agn in debugfs
  iwlwifi: "recover_from_tx_stall" function for 4965

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-4965.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    3 ++-
 3 files changed, 10 insertions(+), 1 deletions(-)

