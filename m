Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYF3J0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/33] iwlwifi driver 06/30 updates
Date: Mon, 30 Jun 2008 17:23:00 +0800
Message-Id: <1214817813-17639-1-git-send-email-yi.zhu@intel.com> (sfid-20080630_112619_490138_2C2EA3C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some iwlwifi patches against wireless-testing GIT tip.
Please apply.

Thanks,
-yi

[PATCH 01/33] iwlwifi: configure uCode to use open loop tx power algorithm
[PATCH 02/33] iwlwifi: Add eeprom version to the version file in sysfs
[PATCH 03/33] iwlwifi: better station table maintenance
[PATCH 04/33] iwlwifi: use iwl_is_associated when possible
[PATCH 05/33] iwlwifi: add REPLY_TX_POWER_DBM_CMD to get_cmd_string
[PATCH 06/33] iwlwifi: send ADD_STA before RXON with assoc bit
[PATCH 07/33] iwlwifi: move RX stats to core, and move temperature to handler
[PATCH 08/33] iwlwifi: don't send REPLY_REMOVE_ALL_STA upon exit
[PATCH 09/33] iwlwifi: move RX handlers to iwl-rx.c
[PATCH 10/33] iwlwifi: remove useless network and duplicate checking
[PATCH 11/33] iwlwifi: setup compressed BA handler
[PATCH 12/33] iwlwifi: move rx aggregation functions to iwl-rx.c
[PATCH 13/33] iwlwifi: remove obsolete lq_ready use
[PATCH 14/33] iwlwifi: fix IBSS association flow
[PATCH 15/33] iwlwifi: keep the STATUS_EXIT_PENDING flag till the end of down flow
[PATCH 16/33] mac80211: add beacon timestamp to beacon template in IBSS
[PATCH 17/33] iwlwifi: adjust TSF in IBSS
[PATCH 18/33] iwlwifi : Patch adds rfkill subsystem for 3945
[PATCH 19/33] iwlwifi: don't bring up interface if RF-kill avoids radio
[PATCH 20/33] iwlwifi: unite common settings of HW params
[PATCH 21/33] iwlwifi: control 11n capabilities through module param
[PATCH 22/33] iwlwifi: Remove unnecessary code
[PATCH 23/33] iwlwifi: eliminate iwl4965_mac_get_tsf
[PATCH 24/33] iwlwifi: blocking mac_start until uCode is complete
[PATCH 25/33] iwlwifi: clean up HW RF-kill state machine and restarts
[PATCH 26/33] iwlwifi: fix 4965 uCode load
[PATCH 27/33] iwlwifi: fix incorrect 5GHz rates reported in monitor mode
[PATCH 28/33] iwlwifi: fix incorrect monitor mode operation
[PATCH 29/33] iwlwifi: drop skb silently for Tx request in monitor mode
[PATCH 30/33] iwlwifi: enable packet injection for iwl3945
[PATCH 31/33] iwlwifi: fix iwl4965 temperature callback calibration issue
[PATCH 32/33] iwl3945: remove RFKILL_STATE_HARD_BLOCKED warnings
[PATCH 33/33] iwlwifi: remove the input device from rfkill_mngr
