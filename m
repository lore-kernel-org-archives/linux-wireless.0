Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1AEAbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5]  update for 2.6.38
Date: Tue,  4 Jan 2011 16:21:58 -0800
Message-Id: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add number of wait functions for PAN related operations.

Johannes Berg (4):
  iwlagn: make iwl_rx_handle static
  iwlagn: properly wait for PAN disable
  iwlagn: return error if PAN disable timeout
  iwlwifi: fix 4965 notification wait setup
  iwlagn: add support for waiting for notifications

 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 +++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   46 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   17 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   23 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   16 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   33 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 +
 8 files changed, 137 insertions(+), 5 deletions(-)

