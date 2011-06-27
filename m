Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1F0Pgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 11:36:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 3.0
Date: Mon, 27 Jun 2011 08:04:33 -0700
Message-Id: <1309187075-3879-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110627_173656_154773_9233EA94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix DMAR error reported by Andy Lutomirski
Also fix cmd queue unmap cause DMA memory leak

Johannes Berg (2):
  iwlagn: fix cmd queue unmap
  iwlagn: map command buffers BIDI

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-tx.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

