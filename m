Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2A1Rhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 12:37:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/4] update for 3.4: iwlwifi 2012-01-28
Date: Sat, 28 Jan 2012 08:30:48 -0800
Message-Id: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120128_183736_716553_4D3B7E39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix scan dwell problem in P2P
We also adding LED disable option in module parameter 

Johannes Berg (2):
  iwlwifi: fix uCode event tracing
  iwlwifi: always restrict scan dwell in P2P

Wey-Yi Guy (2):
  iwlwifi: fix typo
  iwlwifi: add option to disalbe LED

 drivers/net/wireless/iwlwifi/iwl-agn.c      |  101 +++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    4 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   21 +++++-
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    8 +-
 7 files changed, 105 insertions(+), 40 deletions(-)

