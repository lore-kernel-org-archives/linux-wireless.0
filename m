Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZAWVmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/15] iwlwifi driver updates 01/23/2009
Date: Fri, 23 Jan 2009 13:45:08 -0800
Message-Id: <1232747123-7261-1-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224257_444134_E3EECBA9)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly patches for the 3945 porting effort.
In addition this series contains the following:
- a workaround to reduce off channel reception for 4965 when in monitor
mode (patches 1 and 2)
- a kernel oops fix (patch 14) tracked in
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1861
- a printk formatting fix (patch 15)

[PATCH 01/15] iwlwifi: add test to determine if interface in monitor mode
[PATCH 02/15] iwlagn: reduce off channel reception for 4965
[PATCH 03/15] iwl3945: Define send_tx_power
[PATCH 04/15] iwl3945: Use iwlcore scan code
[PATCH 05/15] iwlwifi: make iwl_tx_queue->tfds void*
[PATCH 06/15] iwl3945: Use iwlcore TX queue management routines
[PATCH 07/15] iwl3945: Use iwl-eeprom.c routines
[PATCH 08/15] iwl3945: Use the iwlcore geos routines
[PATCH 09/15] iwlwifi: Remove IWL3945_DEBUG
[PATCH 10/15] iwl3945: Getting rid of priv->antenna
[PATCH 11/15] iwl3945: Add restart_fw module parameter
[PATCH 12/15] iwl3945: Remaining host command cleanups
[PATCH 13/15] iwlwifi: fix probe mask for 39 scan API
[PATCH 14/15] iwlwifi: fix kernel oops when ucode DMA memory allocation failure
[PATCH 15/15] iwlwifi: iwl_tx_queue_alloc : fix warning in printk formatting


Thank you

Reinette
