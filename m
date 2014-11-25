Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59484 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaKYWhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 17:37:53 -0500
Received: by mail-yh0-f50.google.com with SMTP id 29so825460yhl.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 14:37:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4mk1qupb0x91jt5q9b0i7t6u.1416953995543@email.android.com>
References: <AM2PR02MB25805670A3194B8B306F3F0A4730@AM2PR02MB258.eurprd02.prod.outlook.com>
 <CAHNKnsQHDmLdfZwu9SbNLx70Km6CG09o_wJPLWmRGCsXrdfCNA@mail.gmail.com> <4mk1qupb0x91jt5q9b0i7t6u.1416953995543@email.android.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Wed, 26 Nov 2014 01:37:32 +0300
Message-ID: <CAHNKnsRzO0ie0yQ8QFPfUt=v75MrHjXeNbvEivSOB5OObT5Nfg@mail.gmail.com> (sfid-20141125_233756_383507_BDF6DF53)
Subject: Re: [ath5k-devel] Support for ath9k chipset
To: Milos Ivanovic <Milos.Ivanovic@q-free.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc linux-wireless

2014-11-26 1:20 GMT+03:00 Milos Ivanovic <Milos.Ivanovic@q-free.com>:
> Ok. I installed the wirelless card ath9k on Ubuntu.
>
> Only what i need is how can i change the frequency of wirelless card from
> terminal ? Which command ?
>
Action depends on mode of wireless interface. In case of AP you should
specify frequency in the hostapd configuration file, in case of
Managed sta your interface just running on the same channel as the AP
to which it is connected, in case of Mesh or IBSS your should specify
frequency in the same command which you use to start operation. And
finally, if your card run as Monitor you could type "iw mon0 set freq
2412".

More details about iw utility you can find in [1].

1. http://wireless.kernel.org/en/users/Documentation/iw

> Thanks
> Milos
>
>
> Sent from Samsung Mobile
>
>
> -------- Original message --------
> From: Sergey Ryazanov
> Date:25/11/2014 23:10 (GMT+01:00)
> To: Milos Ivanovic
> Cc: ath5k-devel@lists.ath5k.org
> Subject: Re: [ath5k-devel] Support for ath9k chipset
>
> Hi Milos,
>
> 2014-11-25 14:19 GMT+03:00 Milos Ivanovic <Milos.Ivanovic@q-free.com>:
>> Dear all,
>>
>> Please, I need a help about installation Atheros AR9220 on Linux Debian
>> with kernel 3.2.
>>
> For questions about ath9k chips, please, use appropriate mailing list:
> ath9k-devel <ath9k-devel@lists.ath9k.org>
>
>>
>> Can you help me about this issue ? Because I have tried in several ways to
>> do this but without success.
>>
> Could you be more concrete: what do you try do and what exactly issue
> do you faced? That raises your chances to get an answer.
>
>>
>>
>> Thank you in advance,
>>
>>
>>
>> --------------------------------------
>> Milos Ivanovic, M.Sc.
>> Software Engineer
>> --------------------------------------
>> Phone: +381.63.469.824
>> E-mail:
>>
>> milos.ivanovic@q-free.com
>>
>> --------------------------------------
>> Elcom d.o.o.
>> 41h Sinjska Street
>> 11050 Belgrade
>> Serbia
>>
>> VAT: 101821850
>>
>> www.elcombgd.rs
>> --------------------------------------
>
> --
> BR,
> Sergey

-- 
BR,
Sergey
