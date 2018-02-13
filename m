Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minos.uwaterloo.ca ([129.97.128.78]:38050 "EHLO
        minos.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935174AbeBMNcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 08:32:52 -0500
Subject: Re: 802.11ac devices that use Minstrel_HT
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
 <4674890.5ipQsmKAE1@bentobox>
 <00665215-8a85-365d-dcfa-aa9b1aeedd1c@mailservices.uwaterloo.ca>
 <8037020.pGPiyahZAU@bentobox>
 <CAA2SeNLFMKHx4R3RzesFssXz38jeOwtCBfjmxXdEtReO6JJrUQ@mail.gmail.com>
From: Ali Abedi <a2abedi@uwaterloo.ca>
Message-ID: <113de75d-62bc-c0b1-1a3a-a17f6fc2f32a@mailservices.uwaterloo.ca> (sfid-20180213_143256_182353_030FDD44)
Date: Tue, 13 Feb 2018 08:32:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAA2SeNLFMKHx4R3RzesFssXz38jeOwtCBfjmxXdEtReO6JJrUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you, this is extremely helpful for us.
Do you know any device that supports more than 2 spatial streams? (Is 
mt76 capable of supporting more spacial streams at the moment?)

Best,
Ali

On 2/13/2018 8:26 AM, Lorenzo Bianconi wrote:
>> On Dienstag, 13. Februar 2018 07:56:29 CET Ali Abedi wrote:
>>>> So I would currently bet on hwsim (only useful when you only want to have some
>>>> simulations) or mt76. Afaik mt76 was also the one which was used to test the
>>>> VHT rate injection code for monitor interfaces and is therefore quite
>>>> flexible.
>> [...]
>>> Thank you Sven. I was actually wondering what hardware was used to test
>>> the code.
>> It seems Lorenzo Bianconi used an D-Link DIR-860L rev B1 [1]
>>
> Yes, I used it for a while; at the moment to work on mt76 code I am
> using Buffalo wsr1166
> Regards,
>
> Lorenzo
>
>> Kind regards,
>>          Sven
>>
>> [1] https://patchwork.kernel.org/patch/8393091/
