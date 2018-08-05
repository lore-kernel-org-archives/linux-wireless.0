Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:17792 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbeHEUal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Aug 2018 16:30:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 05 Aug 2018 20:18:53 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Ben Greear <greearb@candelatech.com>
Cc: Matthias May <matthias.may@neratec.com>,
        linux-wireless@vger.kernel.org
Subject: Re: ath9k and 16 VAP interfaces?
In-Reply-To: <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
 <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
 <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
Message-ID: <e44c3cf1714d33417fd70bc58610dd40@fami-braun.de> (sfid-20180805_202916_898544_6FD3D7FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using [1]. I was seeing some trouble with powersave + broadcasts, so 
I added [2], so that the queue would get empty faster.

Regards,
M. Braun


[1] 
http://git.fem.tu-ilmenau.de/?p=fem-wlan.git;a=blob;f=package/kernel/mac80211/patches/911-more-ap-interfaces.patch;h=873a6cb7bdb8a7462ffd07c1a50fc87c580f223d;hb=refs/heads/femwlan_stage2.kernel4.9
[2] 
http://git.fem.tu-ilmenau.de/?p=fem-wlan.git;a=blob;f=package/kernel/mac80211/patches/915-use-more-time-for-multicast.patch;h=05d7fb6c2567e1abdef63a4d01f02df7f8501630;hb=refs/heads/femwlan_stage2.kernel4.9
Am 30.07.2018 16:34, schrieb Ben Greear:
> On 07/30/2018 04:13 AM, Matthias May wrote:
>> On 30/07/18 11:40, michael-dev@fami-braun.de wrote:
>>> Do you mean AP interfaces as required for multiple BSS/SSIDs?
>>> 
>>> I'm running a patched ath9k to have hostapd run >8 BSS on a single 
>>> radio.
>>> It works fine since years.
> 
> Yes, I'd love to see any patches you can share on this as well.
> 
> Thanks,
> Ben
> 
>>> 
>>> Regards,
>>> M. Braun
>>> 
>>> 
>>> Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear 
>>> <greearb@candelatech.com>:
>>>> Hello,
>>>> 
>>>> Has anyone tried making ath9k able to support 16 vAP interfaces on a
>>>> single
>>>> radio?  I seem to recall that there were limitations regarding 
>>>> beacon
>>>> timers and such, and that is why the current limit is 8?
>>>> 
>>>> Thanks,
>>>> Ben
>>>> 
>>>> --
>>>> Ben Greear <greearb@candelatech.com>
>>>> Candela Technologies Inc  http://www.candelatech.com
>>> 
>> 
>> Are these patches available somewhere?
>> I'm interested to play with them :)
>> 
>> BR
>> Matthias
>> 
