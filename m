Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46613 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZGVIAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 04:00:39 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MTWkf-0001pl-1a
	for linux-wireless@vger.kernel.org; Wed, 22 Jul 2009 08:00:37 +0000
Received: from bdz194.neoplus.adsl.tpnet.pl ([83.28.11.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 08:00:37 +0000
Received: from kamil.dzida by bdz194.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 08:00:37 +0000
To: linux-wireless@vger.kernel.org
From: Kamil Dzida <kamil.dzida@gmail.com>
Subject: Re: AR5523 driver - old Atheros USB
Date: Wed, 22 Jul 2009 08:00:28 +0000 (UTC)
Message-ID: <loom.20090722T074629-659@post.gmane.org>
References: <43e72e890907211209p5142047cjf821bc536c012f24@mail.gmail.com> 	<20090721210422.GA24285@lst.de> <43e72e890907211424j2c1eecdauf1d8279baec0f6f9@mail.gmail.com> 	<20090721214219.GA25392@lst.de> <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com> 	<928354.18240.qm@web56107.mail.re3.yahoo.com> <43e72e890907211804i1e1fa166y810caa95563bc695@mail.gmail.com> <4A66A482.6050401@erley.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pat Erley <pat-lkml@...> writes:

> 
> Luis R. Rodriguez wrote:
> > On Tue, Jul 21, 2009 at 6:03 PM, Purushotham
> > Nayak<nayak_purushotham@...> wrote:
> >> Hi,
> >>
> >> I'm interested in working on this. I just posted to the Linux driver
project a few days ago if I could work on
> the atheros USB devices. Please let me also know the USB device that uses the
AR5523.
> > 
> > Dan recently purchased one of these devices. Dan any pointers?
> 
> I have a few WPN111 Refurbed devices that are AR5523 based.  Apparently
> there is a WPN111v2 that may or may not be otus supported, I can't confirm 
> that.  Based on pictures from google and the devices I own, the AR5523 ones
> are silver, and the Otus ones are white.  I'd be more than happy to test and
> do what I can to try to help, but my time is limited, so I'm not up for 
> taking the task onto my shoulders right now.
> 
> Pat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

It seems that OpenBSD has driver for AR5523 (AR5005UG and AR5005UX) upstream. I
doubt that they would like to share their code with Linux - like dual licensing
GPL/BSD. Fortunately their documentation mentions which hardware includes those
chipsets, look here:

http://www.openbsd.org/cgi-bin/man.cgi?query=uath&sektion=4&apropos=0&manpath=OpenBSD+Current&arch=i386


Note that Atheros AR5007UG (alternatively known as AR2524/AR5524) is supported
by Linux zd1211rw driver.

Kamil


