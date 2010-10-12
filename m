Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab0JLPzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 11:55:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/3] update for 2.6.37
Date: Tue, 12 Oct 2010 08:53:52 -0700
Message-Id: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3945 was broken because accidentally removed the
num_of_queues parameter for 3945, restore the 
necessary num_of_queues param.

BT coex was broken by runtime DC calibration,
fix by change the initialization sequence. 

Johannes Berg (1):
  iwl3945: fix queue allocation

Wey-Yi Guy (2):
  iiwlagn: always download priority table
  iwlagn: prio_tbl need to download before calibration

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

