Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab0AOVnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.33
Date: Fri, 15 Jan 2010 13:42:57 -0800
Message-Id: <1263591779-14785-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The license was omitted from some new files, fix it here. We also fix a
data transfer stall issue on 5000 series hardware. An equivalent fix has
already been submitted for 1000 and 6000 series hardware.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (1):
  iwlwifi: add license to tracing files

Wey-Yi Guy (1):
  iwlwifi: Fix throughput stall issue in HT mode for 5000

 drivers/net/wireless/iwlwifi/iwl-5000.c     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   26 ++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)

