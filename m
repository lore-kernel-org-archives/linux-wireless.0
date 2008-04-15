Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYDOEQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/12] iwlwifi driver updates
Date: Mon, 14 Apr 2008 21:16:02 -0700
Message-Id: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051621_423087_D2E70747)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains a few iwlwifi driver updates.

Patches 3 to 7 introduces support for WEP HW encryption
acceleration. It supports default and dynamic keys both PSK and 1X
No changes in mac80211 were required.  It also reorganizes security
related code into a new file iwl-sta.c

Please note that patch "iwlwifi: perform bss_info_changed post
association work right away" depends on recent mac80211 patch:
mac80211: no BSS changes to driver from beacons processed during scanning


[PATCH 01/12] iwlwifi: generalize iwlwifi init flow
[PATCH 02/12] iwlwifi: replace sprintf with scnprintf for debugfs output
[PATCH 03/12] iwlwifi: add default WEP key host command
[PATCH 04/12] iwlwifi: default WEP HW encryption
[PATCH 05/12] iwlwifi: add 1X HW WEP support
[PATCH 06/12] iwlwifi: maintain uCode key table state
[PATCH 07/12] iwlwifi: moves security functions to iwl-sta.c
[PATCH 08/12] iwlwifi: Fix byte count table for fragmented packets
[PATCH 09/12] iwl4965: make iwl4956_send_rxon_assoc asynchronous
[PATCH 10/12] iwlwifi: make Makefile more concise
[PATCH 11/12] iwlwifi: perform bss_info_changed post association work right away
[PATCH 12/12] iwlwifi: move shared pointers to iwl_priv

Thank you

Reinette
