Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYLSCox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:44:53 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
Date: Fri, 19 Dec 2008 10:37:00 +0800
Message-Id: <1229654263-21454-1-git-send-email-yi.zhu@intel.com> (sfid-20081219_034456_996264_E32B944A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the first batch for the iwl3945 -> iwlagn merge. This is for
post .29 kernel.

Thanks,
-yi

[PATCH 01/43] iwlwifi: 3945 extract flow handler definitions into iwl-3945-fh.h
[PATCH 02/43] iwlwifi: 3945 unfold iwl-3945-commands.h
[PATCH 03/43] iwlwifi: 3945 remove current_rate from station entry.
[PATCH 04/43] iwlwifi: use iwl-commands.h also in 3945
[PATCH 05/43] iwlwifi: 3945 remove duplicated code from iwl-3945-commands.h
[PATCH 06/43] iwlwifi: 3945 drop usage of union tsf
[PATCH 07/43] iwlwifi: 3945 remove iwl-3945-commands.h
[PATCH 08/43] iwl3945: Getting rid of iwl-3945-debug.h
[PATCH 09/43] iwl3945: Remove DRV_NAME dependenies
[PATCH 10/43] iwl3945: Getting rid of iwl3945_eeprom_channel
[PATCH 11/43] iwl3945: Have consistant and not redefined HW constants
[PATCH 12/43] iwl3945: Use iwl-agn-rs.h rates definitions.
[PATCH 13/43] iwl3945: Getting rid of iwl-3945-led.h
[PATCH 14/43] iwl3945: Remove power related definitions from 3945 code
[PATCH 15/43] iwl3945: iwl3945_queue and iwl3945_channel_info replacement
[PATCH 16/43] iwlwifi: emliminate iwl3945_mac_get_stats mac80211 handler
[PATCH 17/43] iwl3945: Change IWLWIFI_VERSION constant name
[PATCH 18/43] iwl3945: include iwl-core.h
[PATCH 19/43] iwl3945: replace iwl_3945_cfg with iwl_cfg
[PATCH 20/43] iwl3945: move structures from iwl-3945.h to iwl-dev.h
[PATCH 21/43] iwl3945: remove duplicate structures from iwl-3945.h
[PATCH 22/43] iwl3945: replace iwl3945_broadcast_addr with iwl_bcast_addr
[PATCH 23/43] iwlwifi: beautify code
[PATCH 24/43] iwl3945: use iwl_rx_mem_buffer
[PATCH 25/43] iwl3945: use iwl_rx_queue in iwl3945
[PATCH 26/43] iwl3945: use iwl_hw_params in iwl3945_priv
[PATCH 27/43] iwl3945: rename iwl3945_priv variables
[PATCH 28/43] iwl3945: replaces iwl3945_priv with iwl_priv
[PATCH 29/43] iwl3945: use iwl-io.h and delete iwl-3945-io.h
[PATCH 30/43] iwlwifi: add more comments to IWL_DL_xx
[PATCH 31/43] iwlwifi: clean up printing
[PATCH 32/43] iwlwifi: replace IWL_WARNING with IWL_WARN
[PATCH 33/43] iwlwifi: replace IWL_ERROR with IWL_ERR
[PATCH 34/43] iwlwifi: use iwl_cmd instead of iwl3945_cmd
[PATCH 35/43] iwl3945: use iwl_mod_params for 3945
[PATCH 36/43] iwl3945: cleanup and remove duplicate code
[PATCH 37/43] iwl3945: add load ucode op
[PATCH 38/43] iwl3945: add apm ops
[PATCH 39/43] iwl3945: add set_pwr_src
[PATCH 40/43] iwl3945: simplify iwl3945_pci_probe
[PATCH 41/43] iwl3945: release resources before shutting down
[PATCH 42/43] iwl3945: use iwl_get_hw_mode
[PATCH 43/43] iwl3945: use iwl_rb_status
