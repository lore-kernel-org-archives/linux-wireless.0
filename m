Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BFRz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 12:55:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 2.6.39
Date: Sun,  6 Feb 2011 09:42:51 -0800
Message-Id: <1297014173-28964-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We remove unnecessary spin-lock
We also fix compiler error cause by Kconfig setting

Johannes Berg (1):
  iwlwifi: remove unnecessary locking

Wey-Yi Guy (1):
  iwlwifi: fix compiling error with different configuration

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 3 files changed, 4 insertions(+), 8 deletions(-)

