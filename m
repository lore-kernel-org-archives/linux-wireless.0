Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZASX2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/15] iwlwifi driver updates 01/19/2009
Date: Mon, 19 Jan 2009 15:30:20 -0800
Message-Id: <1232407835-19451-1-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002825_206972_A4712D90)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues the 3945 porting work. The extras are:
Patch 2 fixes a potential problem when two or more NICs are present.
In patch 4 we add some debugging to 3945 driver to trace a bug.
In patch 11 we work on the Kconfig file appearance.
In patch 12 we clean up the _tx return code.
Patches 13 to 15 add recognition of new hardware.

[PATCH 01/15] iwlwifi: make iwl-power.c more readable
[PATCH 02/15] iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
[PATCH 03/15] iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
[PATCH 04/15] iwl3945: add debugging for wrong command queue
[PATCH 05/15] iwl3945: Use iwl_txq_update_write_ptr
[PATCH 06/15] iwlwifi: Add TFD library operations
[PATCH 07/15] iwl3945: Use iwl-hcmd host command routines
[PATCH 08/15] iwlwifi: kill scan39
[PATCH 09/15] iwlwifi: remove unused or twice defined members in iwl_priv
[PATCH 10/15] iwlwifi: eliminate power_data_39.
[PATCH 11/15] iwlwifi: correct Kconfig to prevent following entries from not indenting
[PATCH 12/15] iwlwifi: return NETDEV_TX_OK from _tx ops
[PATCH 13/15] iwlwifi: remove static from 5000 structures
[PATCH 14/15] iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
[PATCH 15/15] iwlwifi: add recognition of Intel WiFi Link 100 Series

Thank you

Reinette

