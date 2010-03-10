Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0CJFWX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] fixes for 2.6.34
Date: Tue,  9 Mar 2010 21:22:17 -0800
Message-Id: <1268198539-6656-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two fixes targeting 2.6.34. The first solves a memory corruption
error where the wrong index was used to initialize an array. The second
reverts a patch found in 2.6.34 since it can cause some memory corruption.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (2):
  iwl3945: fix memory corruption
  Revert "iwlwifi: Send broadcast probe request only when asked to"

 drivers/net/wireless/iwlwifi/iwl-3945.c |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |   49 ++++++++++---------------------
 3 files changed, 20 insertions(+), 37 deletions(-)

