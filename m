Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0JGABo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 20:01:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 2.6.37
Date: Wed,  6 Oct 2010 17:00:53 -0700
Message-Id: <1286409655-32679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the firmware module naming for 130 series devices, please merge with
130 enabling patch:
   "iwlagn: define 130 series of WiFi/BT combo devices"

Wey-Yi Guy (2):
  iwlagn: fix module firmware name for 130 series device
  iwlagn: add define for MODULE_FIRMWARE

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-6000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

