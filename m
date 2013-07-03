Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackhole.sdinet.de ([176.9.52.58]:49948 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab3GCW3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 18:29:08 -0400
Date: Thu, 4 Jul 2013 00:28:24 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Xavier <xlinuxwireless@aim.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless is not avalaible ?
In-Reply-To: <8D046351240532F-1114-718F3@webmail-va009.sysops.aol.com>
Message-ID: <alpine.DEB.2.10.1307040022300.29512@aurora.sdinet.de> (sfid-20130704_002912_251961_47C3E5EB)
References: <8D04620FE438D64-1114-7061B@webmail-va009.sysops.aol.com> <alpine.DEB.2.10.1307032001430.29512@aurora.sdinet.de> <8D046351240532F-1114-718F3@webmail-va009.sysops.aol.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 3 Jul 2013, Xavier wrote:

> On Wed, Jul 03, 2013 at 08:02:31PM +0200, Sven-Haegar Koch wrote:
> 
> Hi Sven-Haegar,
> 
> > On Wed, 3 Jul 2013, Xavier wrote:
> > 
> > > Why
> > >
> > > 
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2.5-1.tar.bz2
> > >
> > > is not avalilable ?
> > >
> > > Where it's available ?
> > 
> > Have a look at
> > https://www.kernel.org/pub/linux/kernel/projects/backports/stable/ 
> for
> > newer versions.
> > 
> 
> Thanks for your answer.
> 
> This is a good link, but I need compat-wireless stable for 3.2 version of
> Linux kernel.

"for 3.2 version", or "the wireless code as it was in the 3.2 version"?

Wsing compat-wireless (or now backports) from 3.2 with kernel 3.2 makes 
no sense, at it is exactly the same code.

The backports package 3.10 works with a linux kernel 3.2 - after all, 
thats the reason they are backports.

> In that link, there are all for >= 3.7 Linux kernel version.

Not "for" - FROM.

backports 3.10rcX is the wireless (plus now DRI) code from 3.10rcX to 
use it on older kernels.

> Exist any site for 3.2 Linux kernel version of compat-wireless ?

I have no idea if there are still public archives of the older 
compat-wireless around. At worst you can recreate them using the git 
repositories and the kernel git yourself. 
https://backports.wiki.kernel.org/ may have some documentation about how 
to go about this.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
