Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48763 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1IVPCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:02:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 3.2
Date: Thu, 22 Sep 2011 07:15:35 -0700
Message-Id: <1316700937-22240-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110922_170216_717371_057B2FAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the compiling warning for iwlagn

Emmanuel Grumbach (2):
  iwlagn: remove warning in iwl_rx_handle
  iwlagn: sparse warning priv->temperature is signed

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   17 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    9 ++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

