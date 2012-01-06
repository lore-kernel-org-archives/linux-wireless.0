Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2AFWTq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:46 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/7] update for 3.4: iwlwifi 2012-01-06
Date: Fri,  6 Jan 2012 13:16:26 -0800
Message-Id: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232002_744812_6A8D64A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add and improve the features support for testmode
We also update the Copyright to 2012

Kenny Hsu (4):
  iwlwifi: update testmode command of direct register access
  iwlwifi: enhance testmode command sram_read
  iwlwifi: update error dump in testmode command sram_read
  iwlwifi: add testmode cmd IWL_TM_CMD_APP2DEV_GET_FW_INFO

Wey-Yi Guy (3):
  iwlwifi: don't process the info from uCode if does not has ownership
  iwlwifi: Sanity check for sta_id
  iwlwifi: update Copyright

 drivers/net/wireless/iwlwifi/iwl-1000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   30 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |   13 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-io.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   64 ++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-testmode.h       |   26 +++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |    4 +-
 53 files changed, 166 insertions(+), 105 deletions(-)

