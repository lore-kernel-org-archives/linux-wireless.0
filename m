Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39292 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeG3QJg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 12:09:36 -0400
Subject: Re: ath9k and 16 VAP interfaces?
To: Matthias May <matthias.may@neratec.com>, michael-dev@fami-braun.de,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
 <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com> (sfid-20180730_163422_423810_C6C3D063)
Date: Mon, 30 Jul 2018 07:34:12 -0700
MIME-Version: 1.0
In-Reply-To: <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/30/2018 04:13 AM, Matthias May wrote:
> On 30/07/18 11:40, michael-dev@fami-braun.de wrote:
>> Do you mean AP interfaces as required for multiple BSS/SSIDs?
>>
>> I'm running a patched ath9k to have hostapd run >8 BSS on a single radio.
>> It works fine since years.

Yes, I'd love to see any patches you can share on this as well.

Thanks,
Ben

>>
>> Regards,
>> M. Braun
>>
>>
>> Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear <greearb@candelatech.com>:
>>> Hello,
>>>
>>> Has anyone tried making ath9k able to support 16 vAP interfaces on a
>>> single
>>> radio?  I seem to recall that there were limitations regarding beacon
>>> timers and such, and that is why the current limit is 8?
>>>
>>> Thanks,
>>> Ben
>>>
>>> --
>>> Ben Greear <greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>
>
> Are these patches available somewhere?
> I'm interested to play with them :)
>
> BR
> Matthias
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
