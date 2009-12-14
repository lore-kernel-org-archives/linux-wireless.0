Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27377 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972AbZLNWMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi updates for 2.6.34
Date: Mon, 14 Dec 2009 14:12:19 -0800
Message-Id: <1260828741-22749-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This is an initial effort to (1) reduce confusion in patch submission, and
(2) start working towards separate submissions to wireless-2.6 and
wireless-next-2.6. This series includes features targeting 2.6.34
and is based on wireless-next-2.6. The fixes we submit for 2.6.33 are all
needed in 2.6.34 also, but they are submitted separately since they are
based on wireless-2.6. Please let me know if you need the fixes submitted
against another repo than wireless-2.6 to help with their inclusion
into 2.6.34 or wireless-testing.

Included is the addition of ability to view uCode event log via debugfs. An
error message that can be encountered in normal operation is removed.

These patches are also available from branch wireless-next-2.6 in
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Please let me know what needs to be changed to help make the submission
process work better for you.

Wey-Yi Guy (2):
  iwlwifi: on-screen event log dump
  iwlwifi: remove extra error msg on sensitivity calibration

 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  104 ++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    7 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   24 ++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  101 ++++++++++++++++++--------
 7 files changed, 172 insertions(+), 75 deletions(-)

Thank you

Reinette


