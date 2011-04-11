Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:37004 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1DKMdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 08:33:36 -0400
Message-ID: <4DA2F514.8000708@create-net.org>
Date: Mon, 11 Apr 2011 14:33:24 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Channels 12-13 in europe
References: <4DA2CD1A.3040309@create-net.org> <4DA2CFC0.8000606@googlemail.com>
In-Reply-To: <4DA2CFC0.8000606@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I;ve just installed the crda module and there are indeed some changes. For
example if i set the country code to US I get:

             * 2412 MHz [1] (27.0 dBm)
             * 2417 MHz [2] (27.0 dBm)
             * 2422 MHz [3] (27.0 dBm)
             * 2427 MHz [4] (27.0 dBm)
             * 2432 MHz [5] (27.0 dBm)
             * 2437 MHz [6] (27.0 dBm)
             * 2442 MHz [7] (27.0 dBm)
             * 2447 MHz [8] (27.0 dBm)
             * 2452 MHz [9] (27.0 dBm)
             * 2457 MHz [10] (27.0 dBm)
             * 2462 MHz [11] (27.0 dBm)

Notice the higher tx power. However setting the country to JP, IT, or FR 
I still get:

             * 2412 MHz [1] (20.0 dBm)
             * 2417 MHz [2] (20.0 dBm)
             * 2422 MHz [3] (20.0 dBm)
             * 2427 MHz [4] (20.0 dBm)
             * 2432 MHz [5] (20.0 dBm)
             * 2437 MHz [6] (20.0 dBm)
             * 2442 MHz [7] (20.0 dBm)
             * 2447 MHz [8] (20.0 dBm)
             * 2452 MHz [9] (20.0 dBm)
             * 2457 MHz [10] (20.0 dBm)
             * 2462 MHz [11] (20.0 dBm)
             * 2467 MHz [12] (disabled)
             * 2472 MHz [13] (disabled)
             * 2484 MHz [14] (disabled)


Il 11/04/2011 11:54, Dennis Borgmann ha scritto:
> Hi Roberto!
>
> Did you do EVERYTHING as described on this page:
>
> http://acx100.erley.org/stable.html
>
> I once had a similar error as you have, which was due to not having
> installed crda, if I remember correctly.
>
> Just a thought of mine.
>
> Best regards,
> Dennis
>
> Roberto Riggio schrieb:
>> Hi,
>>
>> I'm using openwrt with the latest compat wireless. Is an ath9k supported
>> wireless NIC supposed to work over channel 12 and 13 if the country code
>> is set to IT?
>>
>> If I run:
>>
>> iw phy phy0 info
>>
>> tis is what i get:
>>
>>          Frequencies:
>>              * 2412 MHz [1] (20.0 dBm)
>>              * 2417 MHz [2] (20.0 dBm)
>>              * 2422 MHz [3] (20.0 dBm)
>>              * 2427 MHz [4] (20.0 dBm)
>>              * 2432 MHz [5] (20.0 dBm)
>>              * 2437 MHz [6] (20.0 dBm)
>>              * 2442 MHz [7] (20.0 dBm)
>>              * 2447 MHz [8] (20.0 dBm)
>>              * 2452 MHz [9] (20.0 dBm)
>>              * 2457 MHz [10] (20.0 dBm)
>>              * 2462 MHz [11] (20.0 dBm)
>>              * 2467 MHz [12] (disabled)
>>              * 2472 MHz [13] (disabled)
>>              * 2484 MHz [14] (disabled)
>>
>> Actually, I get the same even if I set the country code to JP,where also
>> channel 14 should be supported.
>>
>> Thanks
>>


-- 
--------------------------------------------------------
Roberto Riggio, Ph.D.
CREATE-NET
Network&  Security Solutions for Pervasive Computing Systems (iNSPIRE)
Senior Researcher
Via alla Cascata 56/D - 38123 Povo Trento (Italy)
e-mail: roberto.riggio@create-net.org
Tel: (+39) 0461 408400 - interno/extension 708
Fax: (+39) 0461 421157
www.create-net.org/~rriggio
--------------------------------------------------------

The information transmitted is intended only for the person or entity to
which it is addressed and may contain confidential and/or privileged
material. Any review, retransmission, dissemination or other use of, or
taking of any action in reliance upon, this information by persons or
entities other than the intended recipient is prohibited according to
the Italian Law 196/2003 of the Legislature. If you received this in
error, please contact the sender and delete the material from any
computer.

Le informazioni contenute in questo messaggio di posta elettronica e nei
file allegati sono da considerarsi strettamente riservate. Il loro
utilizzo e' consentito esclusivamente al destinatario del messaggio, per
le finalita' indicate nel messaggio stesso. Qualora riceveste questo
messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
darcene notizia via e-mail e di procedere alla cancellazione del
messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
od utilizzarlo per finalita' diverse, costituisce comportamento
contrario ai principi dettati dal D. Lgs. 196/2003.

