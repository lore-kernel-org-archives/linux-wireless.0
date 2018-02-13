Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:43281 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935174AbeBMN0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 08:26:05 -0500
Received: by mail-pg0-f47.google.com with SMTP id f6so9856197pgs.10
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2018 05:26:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8037020.pGPiyahZAU@bentobox>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
 <4674890.5ipQsmKAE1@bentobox> <00665215-8a85-365d-dcfa-aa9b1aeedd1c@mailservices.uwaterloo.ca>
 <8037020.pGPiyahZAU@bentobox>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Tue, 13 Feb 2018 14:26:03 +0100
Message-ID: <CAA2SeNLFMKHx4R3RzesFssXz38jeOwtCBfjmxXdEtReO6JJrUQ@mail.gmail.com> (sfid-20180213_142609_217308_77EEE4B0)
Subject: Re: 802.11ac devices that use Minstrel_HT
To: Sven Eckelmann <sven@narfation.org>
Cc: Ali Abedi <a2abedi@uwaterloo.ca>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Dienstag, 13. Februar 2018 07:56:29 CET Ali Abedi wrote:
>> > So I would currently bet on hwsim (only useful when you only want to have some
>> > simulations) or mt76. Afaik mt76 was also the one which was used to test the
>> > VHT rate injection code for monitor interfaces and is therefore quite
>> > flexible.
> [...]
>> Thank you Sven. I was actually wondering what hardware was used to test
>> the code.
>
> It seems Lorenzo Bianconi used an D-Link DIR-860L rev B1 [1]
>

Yes, I used it for a while; at the moment to work on mt76 code I am
using Buffalo wsr1166
Regards,

Lorenzo

> Kind regards,
>         Sven
>
> [1] https://patchwork.kernel.org/patch/8393091/

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
