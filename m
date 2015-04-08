Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54418 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbDHSld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 14:41:33 -0400
Message-ID: <5525765C.6050808@candelatech.com> (sfid-20150408_204149_622970_C1D2C69D)
Date: Wed, 08 Apr 2015 11:41:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Peer, Ilan" <ilan.peer@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com> <552400F4.5010701@candelatech.com> <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2015 11:29 AM, Peer, Ilan wrote:
> Hi Ben,
> 
>> -----Original Message-----
>> From: Ben Greear [mailto:greearb@candelatech.com]
>> Sent: Tuesday, April 07, 2015 19:08
>> To: Peer, Ilan
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
>> 5.2 GHz band
>>
>> On 04/07/2015 09:05 AM, Ilan Peer wrote:
>>> Previously, VHT capabilities and supported MCSs where set for all
>>> bands, although VHT is only allowed on 5.2 GHz band. Fix it.
>>
>> I saw a patch on ath10k list that enabled VHT for 2.4Ghz for that
>> driver/firmware...are you sure it is absolutely not supported?
>>
> 
> According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates in frequency bands below 6 GHz excluding the 2.4 GHz band", so at least the spec. is clear about it. However, I guess it would be possible to enable VHT for 2.4 as well to enjoy some of benefits, but do you see a reason/use case to enable it also for hwsim?

I just don't see a reason to forbid it since hwsim never goes over the air, and at least
some hardware appears to support AC on 2.4, but I don't care strongly about
the issue one way or another.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

