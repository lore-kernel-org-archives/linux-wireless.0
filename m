Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1BZTBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5]  update for 2.6.39
Date: Sat, 26 Feb 2011 10:46:01 -0800
Message-Id: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We modify the BT config command to support enhanced bt coex for 2000 devices

Wey-Yi Guy (5):
  iwlagn: name change for BT config command
  iwlagn: add bt config structure support for 2000 series
  iwlagn: add BT Session Activity 2 UART message (BT -> WiFi)
  iwlagn: split BT page and inquiry UART msg
  iwlagn: enable BT session 2 type UART for 2000 series

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-2000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   78 +++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-commands.h |  108 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 4 files changed, 158 insertions(+), 30 deletions(-)

