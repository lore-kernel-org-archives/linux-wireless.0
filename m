Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab1I3T14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 15:27:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/1] update for 3.2
Date: Fri, 30 Sep 2011 11:40:19 -0700
Message-Id: <1317408020-16627-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110930_212800_557207_9F144CD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We rename the driver name from iwlagn to iwlwifi. This is the preparation for
future driver partition work to support multiple device architectures.

We will have the alias support for "iwlagn" which will be deprecate on kernel
release 3.5.

Don Fry (1):
  iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 Documentation/feature-removal-schedule.txt |    5 +++
 drivers/net/wireless/Makefile              |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig       |   22 +++++++-------
 drivers/net/wireless/iwlwifi/Makefile      |   40 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 +-
 6 files changed, 39 insertions(+), 33 deletions(-)

