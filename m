Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm1.bt.bullet.mail.ird.yahoo.com ([212.82.108.232]:38029 "EHLO
	nm1.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab3H1QFE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 12:05:04 -0400
From: Marc Murphy <marcmltd@marcm.co.uk>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: 802.11p
Date: Wed, 28 Aug 2013 15:57:59 +0000
Message-ID: <F690310232FDDF4AB457E8B3EF90DDE08D321AF2@MARCM-SBS2011.marcmltd.local> (sfid-20130828_180509_542956_F0C2F8A7)
References: <F690310232FDDF4AB457E8B3EF90DDE08D32184E@MARCM-SBS2011.marcmltd.local>,<CA+icZUW4vbCfEq9-1ewe=O=fADq42y60T2P7YV4cgNBSntQ9gA@mail.gmail.com>
In-Reply-To: <CA+icZUW4vbCfEq9-1ewe=O=fADq42y60T2P7YV4cgNBSntQ9gA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes I saw that post but no response, it was 6 weeks ago.
I have had more success finding the source used for the GCDC and looking to see how different it is from the mainline kernel drivers.

Next is to find an Atheros USB 802.11a stick to do some tests with.

Thanks
Marc

________________________________________
From: Sedat Dilek [sedat.dilek@gmail.com]
Sent: 28 August 2013 15:20
To: Marc Murphy
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.11p

On Wed, Aug 28, 2013 at 2:15 PM, Marc Murphy <marcmltd@marcm.co.uk> wrote:
> Doh ! updated now.
>
> I have had a read through the docs but there is no direct reference to 802.11p.  I initially want to have a play with a couple of embedded units that I have to see if I cant send a message from one to the other but struggling to find any updated ath5 driver.
>

A few weeks ago someone asked about that constellation, check for
"802.11p and ath5k v3.10-rc1" thread on linux-wireless ML.

- Sedat -

> Thanks
> Marc
>
> ________________________________________
> From: Sedat Dilek [sedat.dilek@gmail.com]
> Sent: 28 August 2013 12:23
> To: Marc Murphy
> Cc: linux-wireless@vger.kernel.org
> Subject: Re:
>
> On Wed, Aug 28, 2013 at 1:07 PM, Marc Murphy <marcmltd@marcm.co.uk> wrote:
>> Hello,
>> I have been trawling the mailings and lots of people are asking about 802.11p and I have not managed to find a definitive push back to the mainline kernel.
>>
>
> Hi,
>
> first of all, you should set a "subject" to your email request :-).
>
> I cannot say much about 802.11p, but for first informations I
> recommend the wiki at <http://wireless.kernel.org> and have a look
> into docs section.
>
> For faster replies you can join #linux-wireless IRC channel (Freenode).
>
> - Sedat -
>
>> Is there anywhere in particular that I need to be looking to be able to get the patches so I can have a play ?
>>
>> Thanks
>> Marc--
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
