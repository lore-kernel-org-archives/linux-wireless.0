Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1CKE3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 23:29:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 2.6.39
Date: Thu, 10 Mar 2011 20:13:25 -0800
Message-Id: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add off-channel tx support for P2P

Johannes Berg (2):
  iwlagn: support off-channel TX
  iwlagn: fix offchannel TX bug

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  135 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   87 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   41 +++++----
 6 files changed, 238 insertions(+), 51 deletions(-)

