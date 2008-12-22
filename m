Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYLVDij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:39 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/10] iwlwifi driver 12/22 updates
Date: Mon, 22 Dec 2008 11:31:13 +0800
Message-Id: <1229916683-9772-1-git-send-email-yi.zhu@intel.com> (sfid-20081222_043850_442546_F724CD59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Patches 7~9 are generic iwlwifi cleanup. Others are iwl3945 merging into
iwlagn patches, among which patch 10 should fix a regression reported by
Kalle Valo.

Thanks,
-yi

[PATCH 01/10] iwl3945: rearrange 3945 tfd
[PATCH 02/10] iwl3945: adding utils ops
[PATCH 03/10] iwl3945: sync tx queue data structure with iwlagn
[PATCH 04/10] iwl3945: remove iwl-3945-led.[ch]
[PATCH 05/10] iwl3945: switch to the iwl-core send_card_state routine
[PATCH 06/10] iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
[PATCH 07/10] iwlwifi: move sysfs status entry to debugfs
[PATCH 08/10] iwlwifi: kill retry_rate sysfs for iwlagn
[PATCH 09/10] iwlwifi: fix warning 'Should it be static'
[PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
