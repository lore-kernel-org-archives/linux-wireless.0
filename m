Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51016 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab0JHQsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:48:53 -0400
Message-ID: <4CAF4B70.9050001@candelatech.com>
Date: Fri, 08 Oct 2010 09:48:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: At Santos <atsan@hotmail.co.uk>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl> <SNT111-W2989DC6A52022428756E6FB500@phx.gbl> <20101008111221.5425.qmail@stuge.se> <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com> <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl> <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
In-Reply-To: <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2010 09:45 AM, Luis R. Rodriguez wrote:
> On Fri, Oct 8, 2010 at 9:23 AM, At Santos<atsan@hotmail.co.uk>  wrote:
>>
>>
>>> Actually, you can set tx power with iw now:
>>>
>>> http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
>>>
>>> I will note you will need 2.6.36, or compat-wireless-2.6.36, otherwise
>>> you have to use iwconfig, setting txpower with nl80211 was only added
>>> as of 2.6.36.
>>>
>>> Luis
>>
>> Thanks for the response.
>>
>> I'm running with compat-wireless-2.6.36-rc3-1 and I'm finding that iw
>> doesn't work with fixed or limit:
>>
>> $ sudo iw wlan0 set txpower fixed 20
>> command failed: Operation not supported (-95)
>>
>> So it seems it's broken at the moment.
>> To where should I report the bug?
>
> You can use bugzilla.kernel.org please report it there and we can fix
> it. I can't look into right now though as I'm looking into another
> issue. If someone else has cycles it would be appreciated.

I might be able to work on this, in wireless-testing tree at least.

Thanks,
Ben

>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

