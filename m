Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54222 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1BHAjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 19:39:00 -0500
Message-ID: <4D50909B.1020005@candelatech.com>
Date: Mon, 07 Feb 2011 16:38:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: j@w1.fi, Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org> <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com> <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org> <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com> <4D5033DE.4070701@candelatech.com> <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com> <4D50503E.4090007@candelatech.com> <AANLkTim_rcWdzPhraUaTvC_C3-Tm5_w5xH6xHOK=mviE@mail.gmail.com> <4D505DDD.8050805@candelatech.com> <AANLkTimybx2pQGsy908ZOKCUndQX55vOQy1aToingWSY@mail.gmail.com>
In-Reply-To: <AANLkTimybx2pQGsy908ZOKCUndQX55vOQy1aToingWSY@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2011 03:53 PM, Daniel Halperin wrote:
> On Mon, Feb 7, 2011 at 1:02 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 02/07/2011 12:10 PM, Daniel Halperin wrote:
>>>
>>> On Mon, Feb 7, 2011 at 12:04 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>>
>>>>> Start on 5 GHZ AP with HT Only set.  Scan.  What rate are probes sent
>>>>> at for 2.4 GHz?
>>>
>>> No HT20 is not the same as HT-Only.  I'm not sure how to set that. Jouni?
>>
>> I found a post from a year or so ago that indicates hostapd doesn't
>> support this type of thing (that could have changed, of course).
>>
>> Do you know of any commercial APs that support the HT-only feature?
>> (And/Or a general strategy for configuring it?)
>>
>>>> On 5Ghz channels, they are sent at 6Mbps
>>>> On channel 3 (2.4Ghz), they are sent at 1Mbps
>>>>
>>>>
>>>> That seem right?
>>>
>>> Yes, for a HT20 but not HT Only AP.
>>
>> Seems to me that the probe-request is to any/all APs,
>> so how could we possibly know that we should send it
>> at 6Mbps v/s 1Mbps until we discovered and communicated
>> with it?
>
> Just as there are G-only APs that don't advertise 1-11 Mbps in their
> beacons, there are HT-only APs that don't advertise support for 1-11
> or 6-54 Mbps in their beacons and *only* support MCS rates.

Well, I don't think my changes would have made this any worse,
so if it worked before, it probably still works.

If anyone knows how to configure such a beast, I'll run some
tests.  Or, if someone else has an AP like this, please let
me know if you see any problems with these patches.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

