Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36334 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3LCUO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 15:14:27 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so10093069ead.22
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 12:14:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: p2p@posteo.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8188S
Date: Tue, 03 Dec 2013 21:14:22 +0100
Message-ID: <1708062.P25CKJLDQp@blech> (sfid-20131203_211449_071172_2B6A6B26)
In-Reply-To: <71e5f26b0cd51bcceb26565aa236fe7a@posteo.de>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> <1783016.HDzIMuL15q@blech> <71e5f26b0cd51bcceb26565aa236fe7a@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello - Still don't know your Name - 
On Tuesday, December 03, 2013 08:14:08 PM p2p@posteo.de wrote:
> Am 26.11.2013 21:38 schrieb Christian Lamparter:
>
> We need the "p2p magic" to develop a linux miracast sink.
Sounds a bit like OpenWFD [0], or is this unrelated? 
 
> >> I followed the thread.
> >> It shows me that it makes no sense. I am a beginner and I only can
> >> spent time for it if someone tells me for example: fill this module 
> >> with
> >> code for this specific function. I have good literature and I think 
> >> I
> >> can try to help but not lead something.
> >
> > Hey that's great, that's exactly what needs to be "done". ;-)
> >
> 
> I don't know yet if I have the time to take part. But as I wrote I have 
> a good book which describes in detail driver development for 2.6 kernel.
> 
> What do you think how many LOC have to been written?
Ok?!

rtl8192cu has around 8600 LOCs, rtl8192se has around 10700. That said,
realtek's own 8190n driver comes in at 90 000+ LOCs driver [of course,
that driver comes with its own stack, sme and maybe a few other bells
and whiles]. I guess the answer here is really: take what ever number
you prefer :-D.

Regards,

Christian

[0] <http://www.freedesktop.org/wiki/Software/openwfd/>

