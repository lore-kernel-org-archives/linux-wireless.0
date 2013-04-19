Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:46394 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967957Ab3DSKon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 06:44:43 -0400
Received: by mail-qc0-f171.google.com with SMTP id q2so1917776qch.16
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 03:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Fri, 19 Apr 2013 14:44:26 +0400
Message-ID: <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com> (sfid-20130419_124448_630226_82204ACF)
Subject: Re: very bad work of wl (bcm 43228)
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/19 Julian Calaby <julian.calaby@gmail.com>:
> I'm not completely sure, but I believe your card is supported in the
> latest kernel, however I'm not sure exactly how to install it for your
> version of Ubuntu. The alternative is to install the compat-wireless
> package - it'll be called something like
> linux-backports-modules-cw-3.6-3.6-3.2.0-40-generic. If you use either
> of these methods, your card should work without the
> broadcom-sta-source driver.


I'm already get answers on wireless list that my card not supported =(

--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
