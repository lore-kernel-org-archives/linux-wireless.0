Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45354 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731219AbeISVvS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 17:51:18 -0400
Subject: Re: [PATCH] net: wireless: mediatek: fix mt76 LEDS build error
To: Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, arnd@arndb.de
References: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org>
 <20180907075612.GB2725@localhost.localdomain>
 <87d0tp65km.fsf@kamboji.qca.qualcomm.com> <874lelsc6o.fsf@purkki.adurom.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c5f28a00-3c53-6e0f-bce6-c702e8d8f219@infradead.org> (sfid-20180919_181244_779122_73C5C1ED)
Date: Wed, 19 Sep 2018 09:12:35 -0700
MIME-Version: 1.0
In-Reply-To: <874lelsc6o.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/18 9:07 AM, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>
>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>>
>>>> All of the mt76 driver options use its mac80211.o component,
>>>> which uses led interfaces, so each of them should depend on
>>>> LEDS_CLASS.
>>>>
>>>> Fixes this build error:
>>>>
>>>> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_led_init':
>>>> drivers/net/wireless/mediatek/mt76/mac80211.c:119: undefined
>>>> reference to `devm_of_led_classdev_register'
>>>>
>>>> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
>>>>
>>>
>>> Hi Randy,
>>>
>>> a fix for it has been already proposed by Arnd here:
>>> https://marc.info/?l=linux-wireless&m=151628136830540&w=2
>>> but it has not been applied yet
>>
>> Yet? Arnd's patch is not on my queue as it's from last January and Felix
>> had a comment for it:
>>
>> https://patchwork.kernel.org/patch/10173197/
> 
> So what should we do? Arnd hasn't submitted a new patch so should we
> take this one instead?

No.  Arnd, can you resend your patch?

thanks,
-- 
~Randy
