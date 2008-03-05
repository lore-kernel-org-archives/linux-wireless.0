Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6388 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYCEEYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 23:24:10 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 0/11] iwlwifi driver updates
Date: Tue, 4 Mar 2008 20:22:26 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003CFB151@orsmsx416.amr.corp.intel.com> (sfid-20080305_042414_974807_BE342063)
In-Reply-To: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>,
	<linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 04, 2008 6:09 PM, Chatre, Reinette  wrote:

> This series contain some iwlwifi driver updates. Please note that
> there is one patch to mac80211. 
> 
> [PATCH 01/11] iwlwifi: removing unused priv->config
> [PATCH 02/11] iwlwifi: refactor init geos function
> [PATCH 03/11] iwlwifi: Fix 52 rate report in rx status
> [PATCH 04/11] iwlwifi: 802.11n spec removes AUTO offset for FAT
> channel [PATCH 05/11] mac80211: adding mac80211_tx_control_flags and
> HT flags [PATCH 06/11] iwlwifi: use mac80211_tx_control_flags
> [PATCH 07/11] iwlwifi: extract iwl-csr.h
> [PATCH 08/11] iwlwifi: Move HBUS address to iwl-csr.h
> [PATCH 09/11] iwlwifi: add struct iwl_cfg
> [PATCH 10/11] iwlwifi: Take the fw file name from the iwl_cfg.
> [PATCH 11/11] iwlwifi: Cancel scanning upon association
> 
> 
> Thank you
> 
> Reinette

Sorry - the first three patches are duplicates of what Tomas already
sent to you.

Reinette
