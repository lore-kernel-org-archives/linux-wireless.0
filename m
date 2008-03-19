Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943605AbYCTAAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 20:00:49 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 0/7] iwlwifi and mac80211 updates (TKIP)
Date: Wed, 19 Mar 2008 16:56:20 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003F6F15D@orsmsx416.amr.corp.intel.com> (sfid-20080320_000126_385473_5EF1AAFC)
In-Reply-To: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 19, 2008 4:42 PM, Chatre, Reinette  wrote:

> This series reverts the previous TKIP related patches to mac80211
> and iwlwifi and addresses the issues discussed on the mailing list.
> 
> [PATCH 1/7] tkip: revert TKIP patches
> [PATCH 2/7] iwlwifi-2.6: Cleans up set_key flow
> [PATCH 3/7] iwlwifi-2.6: RX status translation to old scheme
> [PATCH 4/7] mac80211: get a TKIP phase key from skb
> [PATCH 5/7] mac80211: allows driver to request a Phase 1 RX key
> [PATCH 6/7] iwlwifi-2.6: enables HW TKIP encryption
> [PATCH 7/7] iwlwifi-2.6: enables RX TKIP decryption in HW

This may be useful:

The patches reverted by the first patch in this series are titled:

mac80211: allows driver to request a Phase 2 key
mac80211: allows driver to request a Phase 1 RX key
iwlwifi-2.6: Cleans up set_key flow
iwlwifi-2.6: enables HW TKIP security
iwlwifi-2.6: RX status translation to old scheme
mac80211: TKIP enable HW encryption for fragmented packets

Reinette
