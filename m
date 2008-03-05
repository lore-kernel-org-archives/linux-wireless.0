Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYCECKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates
Date: Tue,  4 Mar 2008 18:09:21 -0800
Message-Id: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021029_461518_DE2B6697)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This series contain some iwlwifi driver updates. Please note that there
is one patch to mac80211.

[PATCH 01/11] iwlwifi: removing unused priv->config
[PATCH 02/11] iwlwifi: refactor init geos function
[PATCH 03/11] iwlwifi: Fix 52 rate report in rx status
[PATCH 04/11] iwlwifi: 802.11n spec removes AUTO offset for FAT channel
[PATCH 05/11] mac80211: adding mac80211_tx_control_flags and HT flags
[PATCH 06/11] iwlwifi: use mac80211_tx_control_flags
[PATCH 07/11] iwlwifi: extract iwl-csr.h
[PATCH 08/11] iwlwifi: Move HBUS address to iwl-csr.h
[PATCH 09/11] iwlwifi: add struct iwl_cfg
[PATCH 10/11] iwlwifi: Take the fw file name from the iwl_cfg.
[PATCH 11/11] iwlwifi: Cancel scanning upon association


Thank you

Reinette
