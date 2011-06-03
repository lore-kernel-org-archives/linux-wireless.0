Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19443 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1FCPWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 3.0.1
Date: Fri,  3 Jun 2011 07:54:11 -0700
Message-Id: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172254_165327_35A03CF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do more cleanup works for iwlagn driver

Wey-Yi Guy (5):
  iwlagn: save the latest smps mode
  iwlagn: set smps mode after assoc for 1000 device
  iwlagn: move all post scan functions in one place
  iwlagn: direct call to post_scan function
  iwlagn: call commit_rxon function directly

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   13 ++++---------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   10 ++--------
 8 files changed, 31 insertions(+), 26 deletions(-)

