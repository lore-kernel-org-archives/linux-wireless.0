Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbbDHS3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 14:29:43 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
Date: Wed, 8 Apr 2015 18:29:38 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com> (sfid-20150408_202947_061786_034BEB2B)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
 <552400F4.5010701@candelatech.com>
In-Reply-To: <552400F4.5010701@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

> -----Original Message-----
> From: Ben Greear [mailto:greearb@candelatech.com]
> Sent: Tuesday, April 07, 2015 19:08
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
> 5.2 GHz band
> 
> On 04/07/2015 09:05 AM, Ilan Peer wrote:
> > Previously, VHT capabilities and supported MCSs where set for all
> > bands, although VHT is only allowed on 5.2 GHz band. Fix it.
> 
> I saw a patch on ath10k list that enabled VHT for 2.4Ghz for that
> driver/firmware...are you sure it is absolutely not supported?
> 

According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates in frequency bands below 6 GHz excluding the 2.4 GHz band", so at least the spec. is clear about it. However, I guess it would be possible to enable VHT for 2.4 as well to enjoy some of benefits, but do you see a reason/use case to enable it also for hwsim?

Regards,

Ilan.

