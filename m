Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab2ECV2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/6] update for 3.5: iwlwifi 2012-05-03
Date: Thu,  3 May 2012 14:22:00 -0700
Message-Id: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232845_967537_82F8BE54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix a index mistake in the power module parameter. We also fix an
aggregation bug reported by Daniel Chyan from community. And we add
documentation to explain the bluetooth reduce tx power feature

Amit Beka (1):
  iwlwifi: fix power index handling

Emmanuel Grumbach (2):
  iwlwifi: don't flood logs when HT debug flag is set
  iwlwifi: don't disable AGG queues that are not enabled

Wey-Yi Guy (3):
  iwlwifi: include rssi as part of decision making for reduce txpower
  iwlwifi: add documentation for bt reduced tx power
  iwlwifi: make sure reduced tx power bit is valid

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   37 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   19 ++++++++-----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ++++
 drivers/net/wireless/iwlwifi/iwl-power.c    |    8 ++++-
 4 files changed, 58 insertions(+), 12 deletions(-)

