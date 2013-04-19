Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35848 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3DSLGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 07:06:53 -0400
Received: by mail-wi0-f170.google.com with SMTP id l13so750806wie.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 04:06:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com> <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 19 Apr 2013 21:06:32 +1000
Message-ID: <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com> (sfid-20130419_130657_564651_A73B1492)
Subject: Re: very bad work of wl (bcm 43228)
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	Arend van Spriel <arend@broadcom.com>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasiliy,

On Fri, Apr 19, 2013 at 8:44 PM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
> 2013/4/19 Julian Calaby <julian.calaby@gmail.com>:
>> I'm not completely sure, but I believe your card is supported in the
>> latest kernel, however I'm not sure exactly how to install it for your
>> version of Ubuntu. The alternative is to install the compat-wireless
>> package - it'll be called something like
>> linux-backports-modules-cw-3.6-3.6-3.2.0-40-generic. If you use either
>> of these methods, your card should work without the
>> broadcom-sta-source driver.
>
>
> I'm already get answers on wireless list that my card not supported =(

I was certain I'd heard about support going in, clearly my memory is
wrong. Searching around, you asked this question before. Sorry to
mislead you.

There are two ways that support for your card will happen:
1. The b43 developers will finish reverse engineering it and release
support for it.
2. Broadcom will release support through the brcmsmac driver.

Option 1 will take some time, this is not easy work, you might be able
to help with the development, but it's _very_ technical work. That
said, if you can compile a kernel, you can help with the testing once
all the code starts to get together. I believe that Rafał is working
on this and have CC'd him.

Option 2 may take some time as we're waiting for Broadcom. Arend is
their main person here, I've also CC'd him.

If you're desperate for a good wireless connection on that laptop
right now, your best bet is to buy yourself a cheap USB card, I
personally recommend ones with Atheros chipsets as they're very well
supported and tend to work well. TP-Link make some cheap  and good
ones like the TL-WN821N and TL-WN822N.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
