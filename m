Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYHDIDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/10] iwlwifi driver 08/04 updates
Date: Mon,  4 Aug 2008 16:00:38 +0800
Message-Id: <1217836848-24288-1-git-send-email-yi.zhu@intel.com> (sfid-20080804_100351_310209_8D72B6D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is another series of iwlwifi driver update. Note, the patch 10/10 fixes
a merge problem for wireless-testing GIT with upstream.

Thanks,
-yi

[PATCH 01/10] iwlwifi: HW bug fixes
[PATCH 02/10] iwlwifi: memory allocation optimization
[PATCH 03/10] iwlwifi: kill struct iwl4965_lq_mngr
[PATCH 04/10] iwlwifi: implement iwl5000_calc_rssi
[PATCH 05/10] iwlwifi: fix unhandled interrupt when HW rfkill is on
[PATCH 06/10] iwlwifi: cleanup iwl_tx_skb
[PATCH 07/10] iwlwifi: add level for debugging host command
[PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler
[PATCH 09/10] iwlwifi: grap nic access before accessing periphery registers
[PATCH 10/10] iwl3945: fix merge mistake for packet injection
