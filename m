Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0HRQdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:33:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 2.6.35
Date: Wed, 18 Aug 2010 09:35:20 -0700
Message-Id: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't check WEP keys in AP mode.
Also handle the scan abort condition, iwlwifi should not tell
mac80211 later when scan completed. 

Johannes Berg (2):
  iwlagn: do not check for AP mode for WEP keys
  iwlwifi: do not spuriously call ieee80211_scan_completed

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

