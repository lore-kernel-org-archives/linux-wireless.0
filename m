Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab0JFPXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/6]  update for 2.6.37
Date: Wed,  6 Oct 2010 08:23:07 -0700
Message-Id: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add 130 device support
We also cleanup the code to make more readable for device configuration

Jay Sternberg (1):
  iwlagn: reduce redundant parameter definitions

Wey-Yi Guy (5):
  iwlwifi: schedule to deprecate software scan support
  iwlagn: rename iwl5000_tx_power_dbm_cmd
  iwlwifi: remove uncorrect comments
  iwlagn: rename iwl5000_tx_resp
  iwlagn: define 130 series of WiFi/BT combo devices

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 Documentation/feature-removal-schedule.txt     |   10 +
 drivers/net/wireless/iwlwifi/iwl-1000.c        |  121 ++----
 drivers/net/wireless/iwlwifi/iwl-3945.c        |   43 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c        |   47 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |  191 +++------
 drivers/net/wireless/iwlwifi/iwl-6000.c        |  567 +++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   40 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   47 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   11 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   33 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   61 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    2 +
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   22 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   95 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h        |  129 +++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   58 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-led.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-power.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   22 +-
 27 files changed, 660 insertions(+), 913 deletions(-)

