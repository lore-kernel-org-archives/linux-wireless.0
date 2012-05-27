Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33377 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2E0Mbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 08:31:41 -0400
Received: by dady13 with SMTP id y13so3061798dad.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2012 05:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20417.35821.91808.2702@gargle.gargle.HOWL>
References: <4FC04B5A.1070900@candelatech.com>
	<CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com>
	<20417.35821.91808.2702@gargle.gargle.HOWL>
Date: Sun, 27 May 2012 05:31:40 -0700
Message-ID: <CAJ-Vmo=GmeNG96CX=4topxFDhV6EAEoiXXVBcPn501SUMou+NA@mail.gmail.com> (sfid-20120527_143218_290648_E4083A98)
Subject: Re: Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2012 19:05, Sujith Manoharan <c_manoha@qca.qualcomm.com> wrote:

>> FWIW, FreeBSD was getting 270MBit/sec one-way UDP and 150MBit one-way
>> TCP out of AR9160/AR9280's late last year. I should re-run those tests
>> again now that I've fixed a bunch of things and see if I've regressed.
>> Those are 2T2R devices w/ a Routerstation Pro (AR7161) as the hostap.
>
> 270 Mbps with a 2-stream device ? That seems abnormally high. :)

The 40MHz/MCS15/SGI PHY rate is "300MBit", so I was expecting to get
around 250MBit. That was pretty easy. 270MBit was kind of scary and
showed all kinds of broken corner cases.

I'll go and try FreeBSD-HEAD again with all the lock debugging
disabled and post results. It's quite possible that I'm
mis-remembering. :)



Adrian
