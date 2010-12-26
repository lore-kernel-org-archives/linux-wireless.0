Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab0LZS1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:27:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/3] update for 2.6.38
Date: Sun, 26 Dec 2010 10:17:55 -0800
Message-Id: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix a FH error bug in monitor mode
We also make some minor chages for better coding

Johannes Berg (1):
  iwlagn: fix FH error

Wey-Yi Guy (2):
  iwlwifi: remove extra string
  iwlwifi: remove reference to Gen2

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-led.c |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

