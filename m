Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbZLBUwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 15:52:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi updates 12/02/2009
Date: Wed,  2 Dec 2009 12:52:58 -0800
Message-Id: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a fix to a recent feature that accidentally duplicated some
information during printing of uCode event log. We add some more debug
information to indicate the ucode type when an error occurs. Finally we
remove the driver version that has been causing confusion and use the
kernel version as driver version instead.

Reinette Chatre (1):
  iwlwifi: driver version track kernel version

Wey-Yi Guy (2):
  iwl3945: remove duplicated event logging code
  iwlwifi: indicate uCode type when fail dump error/event log

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   13 +------------
 3 files changed, 10 insertions(+), 15 deletions(-)

