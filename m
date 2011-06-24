Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1FXTVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:21:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 3.0
Date: Fri, 24 Jun 2011 11:49:32 -0700
Message-Id: <1308941374-29323-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_212128_360729_8AA69737)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the incorrect type due to interface changes type to a P2P type,

ALso fix the bug introduced by 4ce7cc2b09553a91d4aea014c39674685715173a
iwlagn: support multiple TBs per command


Emmanuel Grumbach (1):
  iwlagn: Fix a bug introduced by the HUGE command removal

Johannes Berg (1):
  iwlagn: fix change_interface for P2P types

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

