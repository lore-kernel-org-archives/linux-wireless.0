Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:42742 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964776AbeBMNfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 08:35:13 -0500
Received: by mail-pg0-f42.google.com with SMTP id y8so2638700pgr.9
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2018 05:35:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <113de75d-62bc-c0b1-1a3a-a17f6fc2f32a@mailservices.uwaterloo.ca>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
 <4674890.5ipQsmKAE1@bentobox> <00665215-8a85-365d-dcfa-aa9b1aeedd1c@mailservices.uwaterloo.ca>
 <8037020.pGPiyahZAU@bentobox> <CAA2SeNLFMKHx4R3RzesFssXz38jeOwtCBfjmxXdEtReO6JJrUQ@mail.gmail.com>
 <113de75d-62bc-c0b1-1a3a-a17f6fc2f32a@mailservices.uwaterloo.ca>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Tue, 13 Feb 2018 14:35:12 +0100
Message-ID: <CAA2SeNJmJCYwdvyZ3aqVWoAhC9ntuwZJSnWHi1Z1Wc47TZ16jQ@mail.gmail.com> (sfid-20180213_143517_529619_7423842E)
Subject: Re: 802.11ac devices that use Minstrel_HT
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: Sven Eckelmann <sven@narfation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Thank you, this is extremely helpful for us.
> Do you know any device that supports more than 2 spatial streams? (Is mt76
> capable of supporting more spacial streams at the moment?)
>
> Best,
> Ali
>
>
> On 2/13/2018 8:26 AM, Lorenzo Bianconi wrote:
>>>
>>> On Dienstag, 13. Februar 2018 07:56:29 CET Ali Abedi wrote:
>>>>>
>>>>> So I would currently bet on hwsim (only useful when you only want to
>>>>> have some
>>>>> simulations) or mt76. Afaik mt76 was also the one which was used to
>>>>> test the
>>>>> VHT rate injection code for monitor interfaces and is therefore quite
>>>>> flexible.
>>>
>>> [...]
>>>>
>>>> Thank you Sven. I was actually wondering what hardware was used to test
>>>> the code.
>>>
>>> It seems Lorenzo Bianconi used an D-Link DIR-860L rev B1 [1]
>>>
>> Yes, I used it for a while; at the moment to work on mt76 code I am
>> using Buffalo wsr1166
>> Regards,
>>
>> Lorenzo
>>
>>> Kind regards,
>>>          Sven
>>>
>>> [1] https://patchwork.kernel.org/patch/8393091/
>
>

mt76 driver supports just 2x2:2 based devices for the moment

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
