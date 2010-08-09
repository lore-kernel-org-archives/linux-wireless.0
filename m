Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0HIRxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 13:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/1] fix for 2.6.35
Date: Mon,  9 Aug 2010 10:57:01 -0700
Message-Id: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch required for 2.6.35 to fix 5GHz association problem. Without this,
iwlagn device will have issue connecting to 11a AP 

Johannes Berg (1):
  iwlagn: fix rts cts protection

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   18 +-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   19 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   20 +------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   85 +++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   29 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +-
 11 files changed, 87 insertions(+), 133 deletions(-)

