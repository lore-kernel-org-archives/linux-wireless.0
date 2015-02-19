Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33382 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbBSFDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 00:03:50 -0500
Message-ID: <54E56EAC.2030906@candelatech.com> (sfid-20150219_060413_085151_CC377132)
Date: Wed, 18 Feb 2015 21:03:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>, linux-wireless@vger.kernel.org
Subject: Re: station kickout
References: <54D29F71.50603@candelatech.com> <87d25bi98f.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d25bi98f.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/15/2015 05:40 AM, Kalle Valo wrote:
> (Adding linux-wireless)
>
> Ben Greear <greearb@candelatech.com> writes:
>
>> In AP mode, it seems that 3.17-ish kernels (at least) always set station kickout
>> to hard-coded value of 50.
>>
>> Is this something that should be configurable?  Maybe a module parameter
>> if nothing else?
>
> Or should we add this to nl80211/cfg80211/mac80211? I would guess other
> drivers also have similar functionality.

I guess that is up to Johannes.  Do we really gain anything useful by letting
firmware take care of this?  Might be best to just disable the firmware option
entirely and let the rest of the mac80211 stack take care of detecting
loss of connectivity?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
