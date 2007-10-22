Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:13988 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXJVVeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 17:34:20 -0400
Received: by ug-out-1314.google.com with SMTP id z38so26584ugc
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 14:34:17 -0700 (PDT)
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Date: Mon, 22 Oct 2007 23:52:57 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <1193067896.30205.9.camel@localhost.localdomain> <20071022211325.GF28190@elf.ucw.cz>
In-Reply-To: <20071022211325.GF28190@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710222352.57543.IvDoorn@gmail.com> (sfid-20071022_223424_554199_A7F839F2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007, Pavel Machek wrote:
> Hi!
> 
> > > > This device is NOT a Ralink USB wifi adapter!
> > > > 
> > > > Get the windows driver in this link and see for yourself.
> > > > http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> > > > (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))
> > > 
> > > Thanks a lot. With some patches, I got driver from conitech.it to
> > > compile and partly work on 2.6.23. I can now transmit packets but not
> > > yet receive them.
> > > 
> > > (use Makefile.26 instead of Makefile)
> > 
> > I couldn't find any license info immediately visible; are you sure it's
> > GPL?
> 
> Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.

That doesn't say much, some manufacturers add that line to their driver
 just to prevent the module loader complaining about a non-GPL driver...

There should be a copyright notice or a license file accompanied with
the driver that clearly states the license of the driver.

Ivo
