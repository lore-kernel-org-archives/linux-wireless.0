Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:32505 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbYJXGsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:40 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/10] iwlwifi driver updates
Date: Thu, 23 Oct 2008 23:48:48 -0700
Message-Id: <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084851_055248_0619F098)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Some iwlwifi updates.

[PATCH 01/10] iwlwifi: refactor TX response flow
[PATCH 02/10] iwlwifi: don't update TFD free counter for invalid station
[PATCH 03/10] iwlwifi: parametrize eeprom versions
[PATCH 04/10] iwlwifi: calibration command namespace renaming
[PATCH 05/10] iwlwifi: convert correctly rate_n_flags to PLCP index for mimo3 packets
[PATCH 06/10] iwlwifi: clear scanning bits upon failure
[PATCH 07/10] iwlwifi: refactor tx byte count table usage
[PATCH 08/10] iwlwifi: run through spell checker
[PATCH 09/10] iwl3945: iwl3945_mac_get_tsf() should not return zero
[PATCH 10/10] iwlwifi: Update reclaim flag

John, the merge error seen with "iwlwifi: refactor TX response flow"
was caused by conflict with "mac80211/drivers: rewrite the rate control
API". These conflicts have now been resolved in this new patch.

Thank you very much

Reinette


