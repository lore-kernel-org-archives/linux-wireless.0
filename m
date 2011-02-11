Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab1BKUUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:20:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 2.6.39
Date: Fri, 11 Feb 2011 12:06:59 -0800
Message-Id: <1297454821-14904-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix a system hung issue by not setup the proper function pointer
for 2000 series devices

Wey-Yi Guy (2):
  iwlagn: donot process bt update when bt coex disable
  iwlagn: handle bt defer work in 2000 series

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-2000.c    |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   12 +++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

