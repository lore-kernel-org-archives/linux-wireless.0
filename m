Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYGKD4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/14] iwlwifi driver 07/11 updates
Date: Fri, 11 Jul 2008 11:53:28 +0800
Message-Id: <1215748422-12672-1-git-send-email-yi.zhu@intel.com> (sfid-20080711_055652_394900_DA6E20F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series of iwlwifi driver includes some LED fix and cleanup.
It also increased the iwlwifi version number to 1.3.27. After it is
applied, users need to download and use the new 4965 firmware
iwlwifi-4965-ucode-228.57.2.21.tgz we just released at
http://intellinuxwireless.org/?n=Downloads

Thanks,
-yi

[PATCH 01/14] iwl3965: remove useless network and duplicate checking
[PATCH 02/14] iwlwifi: adding pci device ids to iwl_hw_card_ids
[PATCH 03/14] iwlwifi: fixes RTS / CTS support
[PATCH 04/14] iwlwifi: remove post associate work
[PATCH 05/14] iwlwifi: rs always set lq_sta->priv
[PATCH 06/14] iwlwifi: make iwl4965_mac_conf_tx in atomic context
[PATCH 07/14] iwlwifi: differentiate 4965 and 5000 hw ampdu queues number
[PATCH 08/14] iwlwifi: fix LED stall
[PATCH 09/14] iwlwifi: LED use correctly blink table
[PATCH 10/14] iwlwifi: unify 4965 and 5000 scanning code
[PATCH 11/14] iwlwifi: enable active scanning
[PATCH 12/14] iwlwifi: send TXPOWER command after a new RXON command
[PATCH 13/14] iwlwifi: Fix LEDs for 3945
[PATCH 14/14] iwlwifi: make index unsigned int for iwl_send_led_cmd
