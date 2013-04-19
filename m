Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34329 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab3DSLUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 07:20:43 -0400
Received: by mail-qc0-f178.google.com with SMTP id d10so92237qca.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 04:20:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
 <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com> <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Fri, 19 Apr 2013 15:20:27 +0400
Message-ID: <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com> (sfid-20130419_132047_810858_F41CCC74)
Subject: Re: very bad work of wl (bcm 43228)
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/19 Julian Calaby <julian.calaby@gmail.com>:
> I was certain I'd heard about support going in, clearly my memory is
> wrong. Searching around, you asked this question before. Sorry to
> mislead you.
>

Not worry. Thanks for answers.

> There are two ways that support for your card will happen:
> 1. The b43 developers will finish reverse engineering it and release
> support for it.
> 2. Broadcom will release support through the brcmsmac driver.
>
> Option 1 will take some time, this is not easy work, you might be able
> to help with the development, but it's _very_ technical work. That
> said, if you can compile a kernel, you can help with the testing once
> all the code starts to get together. I believe that Rafał is working
> on this and have CC'd him.

If somebody provide me steps that i need to to - i'm ready to help.

>
> Option 2 may take some time as we're waiting for Broadcom. Arend is
> their main person here, I've also CC'd him.
>

Hmm , as i see broadcom not very interesting with opensource =( (i
have broadcom cardreader in my
notebook and its not respond when insert card..., bug stays open...)

> If you're desperate for a good wireless connection on that laptop
> right now, your best bet is to buy yourself a cheap USB card, I
> personally recommend ones with Atheros chipsets as they're very well
> supported and tend to work well. TP-Link make some cheap  and good
> ones like the TL-WN821N and TL-WN822N.

Thanks. But IMHO i have adapter with bluetooth and wifi integrated (as
i think) and buy wifi+bluetooth in russia not very simple =)


--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
