Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54262 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3DZHRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 03:17:47 -0400
Received: by mail-qa0-f44.google.com with SMTP id j8so97136qah.17
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 00:17:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACaajQuC3QpcEVnDZA7nCJ_6mmSNafn5zZp=QMdomzHUQ7AsSQ@mail.gmail.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
 <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
 <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
 <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com>
 <517199D4.9070702@broadcom.com> <CACaajQuC3QpcEVnDZA7nCJ_6mmSNafn5zZp=QMdomzHUQ7AsSQ@mail.gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Fri, 26 Apr 2013 11:17:30 +0400
Message-ID: <CACaajQtbR5Utac82Zik00dQZYiE=tcDRmhWDt17BYEHDOj1Z2w@mail.gmail.com> (sfid-20130426_091751_233993_5D770149)
Subject: Re: very bad work of wl (bcm 43228)
To: Arend van Spriel <arend@broadcom.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any news ?

2013/4/21 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> 2013/4/19 Arend van Spriel <arend@broadcom.com>:
>> I have no quick solution so need to more detailed info. For these kind of
>> questions it always helps to provide kernel log and output from commands
>> like lspci and lsusb.
>
>
> Now i'm sometimes not able ping my wifi hot spot (only on 43228, on
> 4311 all works fine with b43 driver)
> lspci:
> 03:00.0 0280: 14e4:4359
>         Subsystem: 105b:e04b
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at c0500000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-00-b9-ff-ff-fc-08-ed
>         Capabilities: [16c] Power Budgeting <?>
>         Kernel driver in use: wl
>         Kernel modules: wl
>
>
> Some logs from kernel and ping in attached file. I'm try to send this
> email ten times, becouse wifi very bad work's with this driver =(
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov@selfip.ru
> jabber: vase@selfip.ru



-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
