Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from keil-draco.com ([216.193.185.50]:50043 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXJVVrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 17:47:53 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Date: Mon, 22 Oct 2007 17:42:36 -0400
Cc: Pavel Machek <pavel@ucw.cz>, Dan Williams <dcbw@redhat.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <20071022211325.GF28190@elf.ucw.cz> <200710222352.57543.IvDoorn@gmail.com>
In-Reply-To: <200710222352.57543.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710221742.36693.dhazelton@enter.net> (sfid-20071022_224757_160985_7C52991C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007 17:52:57 Ivo van Doorn wrote:
> On Monday 22 October 2007, Pavel Machek wrote:
> > Hi!
> >
> > > > > This device is NOT a Ralink USB wifi adapter!
> > > > >
> > > > > Get the windows driver in this link and see for yourself.
> > > > > http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> > > > > (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))
> > > >
> > > > Thanks a lot. With some patches, I got driver from conitech.it to
> > > > compile and partly work on 2.6.23. I can now transmit packets but not
> > > > yet receive them.
> > > >
> > > > (use Makefile.26 instead of Makefile)
> > >
> > > I couldn't find any license info immediately visible; are you sure it's
> > > GPL?
> >
> > Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
>
> That doesn't say much, some manufacturers add that line to their driver
>  just to prevent the module loader complaining about a non-GPL driver...
>
> There should be a copyright notice or a license file accompanied with
> the driver that clearly states the license of the driver.

Lacking an explicitly stated license it can be argued that, since the 
MODULE_LICENSE() macro is meant to define the actual license on the code, 
this code is GPL. No, it isn't an explicit definition, but lacking any other 
signs of the license, the implicit declaration of it being GPL is (or should 
be) enough to deflect charges of copyright infringement.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
