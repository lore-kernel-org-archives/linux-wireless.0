Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbXLRPB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 10:01:28 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 1/1] mac80211: pass in PS_POLL frames
Date: Tue, 18 Dec 2007 17:00:50 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04313242@hasmsx411.ger.corp.intel.com> (sfid-20071218_150131_783481_EC51D2D6)
In-Reply-To: <1197981597.4885.111.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>>> +     if (sdata->type == IEEE80211_IF_TYPE_STA)
>>>> +             return TXRX_DROP;
>>>
>>> Should we maybe do the test explicitly for when we want it, i.e.
>>> AP/VLAN/IBSS cases? Just thinking of the mesh networking stuff etc.
>>> that's being added...
>> 
>> no problem, i'll send it over. currently i see only AP mode as
relevant.

> But I think that if we have a station in a VLAN then we'll have the
VLAN
> interface at this point, no? I guess we really need to test that
anyway,
> I wish hostapd could do VLANs without RADIUS.

Agree, I will add the VLAN as well.

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

