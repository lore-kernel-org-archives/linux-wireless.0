Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1FXTjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 3.1
Date: Fri, 24 Jun 2011 12:07:12 -0700
Message-Id: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213923_581421_B57895EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add more support for P2P functions
We also utilize the existing PM ops macro

Johannes Berg (5):
  iwlagn: use PM ops macro
  iwlagn: fix cmd queue unmap
  iwlagn: extend host command timeout
  iwlagn: fill beacon TX rate properly
  iwlagn: don't use CCK rates for P2P interfaces

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   17 +++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   26 ++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 -------
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c      |    9 +--------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    5 +----
 9 files changed, 40 insertions(+), 43 deletions(-)

