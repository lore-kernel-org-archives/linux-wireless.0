Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2475 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab2D0Xf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 19:35:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] update for 3.5: iwlwifi 2012-04-27
Date: Fri, 27 Apr 2012 16:29:37 -0700
Message-Id: <1335569379-25113-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120428_013530_132605_1EFBD25C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix sparse complain and remove the out-of-dated defines

Wey-Yi Guy (2):
  iwlwifi: modify #ifdef to avoid sparse complain
  iwlwifi: remove the iwl_shared reference

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn.c       |   35 ++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    6 ++--
 3 files changed, 21 insertions(+), 22 deletions(-)

