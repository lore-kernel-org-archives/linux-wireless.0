Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45783 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1ECKjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 06:39:52 -0400
Received: by yxs7 with SMTP id 7so2021260yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 03:39:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DBFCD59.3030505@create-net.org>
References: <4DBF1967.9010604@candelatech.com>
	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
	<4DBFCD59.3030505@create-net.org>
Date: Tue, 3 May 2011 18:39:51 +0800
Message-ID: <BANLkTikXj81VtTNTYgGXOBZqHeL-jfcSDQ@mail.gmail.com> (sfid-20110503_123955_238865_E0F8D5D0)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Then there's something wrong with the patch. Where's the latest version of it?

ath9k worked fine with the SR71A the last time I checked (which was
admittedly 8 weeks ago now.)



Adrian

On 3 May 2011 17:39, Roberto Riggio <roberto.riggio@create-net.org> wrote:
> well i'm also having troubles in injecting traffic at 11n rates over a raw
> interface,
> instead everything is working fine if I try to inject traffic at 11bga
> rates. I'm using
> the patch recently posted by matteo croce in order to specify 11n mcs codes.
>
> the card that i;m using is exactly an sr71a. I hear that packet injection is
> working
> fine for people using the ubiquiti rocket M devices.
>
> R.
>
> Il 03/05/2011 08:13, Adrian Chadd ha scritto:
>>
>> The AR9160/SR71-A should be supported by ath9k. They're just 2x2
>> stream devices using 3 radios.
>>
>> What do you mean by "not even supported" ?
>>
>> If the SR71-A isn't working for you then please email the ath9k list
>> and I'll take a look. I have a bunch of SR71-A hardware here to tinker
>> with.
>>
>>
>>
>>
>> Adrian
>>
>> On 3 May 2011 04:51, Ben Greear<greearb@candelatech.com>  wrote:
>>>
>>> Hello!
>>>
>>> We are trying to find some Atheros NICs that support 3x3
>>> MIMO, but we are having a hard time.
>>>
>>> We mistakenly ordered some Ubiquity SR71-A NICs, but those aren't
>>> even supported by ath9k it seems (visible chipset is AR9160-AC1E).
>>> There are some other SR71 NICs that *do* work (AR9160-BC1A), but
>>> hard to order that specific version.
>>>
>>> Sparklan seems to make one based on AR9380, but they are not
>>> in stock any place we could find.
>>>
>>> Anyone know of any others that are available to the public
>>> in small quantities?
>>>
>>> Thanks,
>>> Ben
>>>
>>> --
>>> Ben Greear<greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> --------------------------------------------------------
> Roberto Riggio, Ph.D.
> CREATE-NET
> Network&  Security Solutions for Pervasive Computing Systems (iNSPIRE)
> Senior Researcher
> Via alla Cascata 56/D - 38123 Povo Trento (Italy)
> e-mail: roberto.riggio@create-net.org
> Tel: (+39) 0461 408400 - interno/extension 708
> Fax: (+39) 0461 421157
> www.create-net.org/~rriggio
> --------------------------------------------------------
>
> The information transmitted is intended only for the person or entity to
> which it is addressed and may contain confidential and/or privileged
> material. Any review, retransmission, dissemination or other use of, or
> taking of any action in reliance upon, this information by persons or
> entities other than the intended recipient is prohibited according to
> the Italian Law 196/2003 of the Legislature. If you received this in
> error, please contact the sender and delete the material from any
> computer.
>
> Le informazioni contenute in questo messaggio di posta elettronica e nei
> file allegati sono da considerarsi strettamente riservate. Il loro
> utilizzo e' consentito esclusivamente al destinatario del messaggio, per
> le finalita' indicate nel messaggio stesso. Qualora riceveste questo
> messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
> darcene notizia via e-mail e di procedere alla cancellazione del
> messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
> divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
> od utilizzarlo per finalita' diverse, costituisce comportamento
> contrario ai principi dettati dal D. Lgs. 196/2003.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
