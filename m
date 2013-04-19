Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61348 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab3DSKlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 06:41:52 -0400
Received: by mail-wi0-f181.google.com with SMTP id c10so590973wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 03:41:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 19 Apr 2013 20:41:31 +1000
Message-ID: <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com> (sfid-20130419_124156_010612_D8D5E6E3)
Subject: Re: very bad work of wl (bcm 43228)
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasiliy,

On Fri, Apr 19, 2013 at 6:27 PM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
> Hello. Sorry for my email. But sometimes ago i bought acer aspire
> v5-171 with broadcom wireless =(.
> After two weeks i have many slowdons and unstable network speed with
> my wifi. Signal of wifi hotspot high. Other notebook (dell 1501 with
> b43 driver - very big thanks to reverse ingenering it!!) i have stable
> speed.
>
> What i need to provide to solve my problems?
> I'm use ubuntu 12.04 with broadcom-sta-source (5.100.82.112-4)

I'm not completely sure, but I believe your card is supported in the
latest kernel, however I'm not sure exactly how to install it for your
version of Ubuntu. The alternative is to install the compat-wireless
package - it'll be called something like
linux-backports-modules-cw-3.6-3.6-3.2.0-40-generic. If you use either
of these methods, your card should work without the
broadcom-sta-source driver.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
