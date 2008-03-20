Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2198 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbYCTUjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 16:39:08 -0400
Date: Thu, 20 Mar 2008 16:21:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/7] iwlwifi and mac80211 updates (TKIP)
Message-ID: <20080320202144.GA30762@tuxdriver.com> (sfid-20080320_203913_209921_2C35BC34)
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com> <D936D925018D154694D8A362EEB0892003F6F15D@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D936D925018D154694D8A362EEB0892003F6F15D@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 04:56:20PM -0700, Chatre, Reinette wrote:
> On Wednesday, March 19, 2008 4:42 PM, Chatre, Reinette  wrote:
> 
> > This series reverts the previous TKIP related patches to mac80211
> > and iwlwifi and addresses the issues discussed on the mailing list.
> > 
> > [PATCH 1/7] tkip: revert TKIP patches
> > [PATCH 2/7] iwlwifi-2.6: Cleans up set_key flow
> > [PATCH 3/7] iwlwifi-2.6: RX status translation to old scheme
> > [PATCH 4/7] mac80211: get a TKIP phase key from skb
> > [PATCH 5/7] mac80211: allows driver to request a Phase 1 RX key
> > [PATCH 6/7] iwlwifi-2.6: enables HW TKIP encryption
> > [PATCH 7/7] iwlwifi-2.6: enables RX TKIP decryption in HW
> 
> This may be useful:
> 
> The patches reverted by the first patch in this series are titled:
> 
> mac80211: allows driver to request a Phase 2 key
> mac80211: allows driver to request a Phase 1 RX key
> iwlwifi-2.6: Cleans up set_key flow
> iwlwifi-2.6: enables HW TKIP security
> iwlwifi-2.6: RX status translation to old scheme
> mac80211: TKIP enable HW encryption for fragmented packets

FWIW, I'll revert those patches individually.  Thanks for the hint
on which ones! :-)

John
-- 
John W. Linville
linville@tuxdriver.com
