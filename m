Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1JNUog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/6] update for 3.2
Date: Fri, 14 Oct 2011 12:54:42 -0700
Message-Id: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224439_755731_EC2212CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We address the race issue point out by Stanislaw.
We also fix a Wowlan firmware related problem.
Plus more cleanup works 

Don Fry (2):
  iwlagn: remove unnecessary type for tracing operations
  iwlagn: simplify iwl_alloc_all

Emmanuel Grumbach (1):
  iwlagn: fix the race in the unmapping of the HCMD

Johannes Berg (2):
  iwlagn: update wowlan API
  iwlagn: use 6 Mbps rate for no-CCK scans

Wey-Yi Guy (1):
  iwlwifi: HW rev for 105 and 135 series

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

kernel.org is back, but I still not establish my account yet; so all the
patches are not push into git.kernel.org yet. I will push as soon I have my kernel.org account ready


 drivers/net/wireless/iwlwifi/iwl-agn.c        |   23 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   27 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-csr.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h   |   23 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-scan.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   12 +++++++---
 7 files changed, 57 insertions(+), 37 deletions(-)

