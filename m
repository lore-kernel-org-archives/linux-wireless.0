Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40126 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbbDXPfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 11:35:09 -0400
Message-ID: <553A630B.9060306@candelatech.com> (sfid-20150424_173513_931859_FC6CC55F)
Date: Fri, 24 Apr 2015 08:36:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
References: <5523273F.4060803@candelatech.com>	<CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>	<CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com>	<552406E4.50600@candelatech.com>	<55241567.3010703@candelatech.com>	<21796.40851.132919.363957@gargle.gargle.HOWL>	<55304F9D.1060301@candelatech.com> <21818.22087.358832.866965@gargle.gargle.HOWL>
In-Reply-To: <21818.22087.358832.866965@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2015 07:42 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>>> TSF would jump around since the HW would sync with the
>>> received beacons and this will happen in both IBSS and station
>>> mode. Hence the limitation, but I think OpenWrt has a one-liner
>>> to remove this restriction...
>>
>> It seems I can only do a single VAP on ath9k as well?
>>
>> Is that per design?
>
> I was referring to ath9k, but it probably applies to ath10k too.
> But yes, IBSS is restricted to a single interface by design.
>
> Sujith
>

My VAP issues were due to regulatory domain issues it seems,
after fixing that I could bring up 8 VAPs on ath9k.

I also added that patch to allow IBSS + other combinations, but
I haven't actually done any real testing with that config.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

