Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:24817 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYIVVSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 17:18:49 -0400
Received: by ik-out-1112.google.com with SMTP id c30so996130ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 14:18:47 -0700 (PDT)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: what is the states of rt2800 driver?
Date: Mon, 22 Sep 2008 23:18:44 +0200
Cc: "Xu, Martin" <martin.xu@intel.com>, linux-wireless@vger.kernel.org,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>
References: <200808272222.53719.IvDoorn@gmail.com> <200809221937.35900.IvDoorn@gmail.com> <1222117314.4670.10.camel@localhost>
In-Reply-To: <1222117314.4670.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809222318.44222.IvDoorn@gmail.com> (sfid-20080922_231852_829710_365A0013)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 September 2008, Mattias Nissler wrote:
> On Mon, 2008-09-22 at 19:37 +0200, Ivo van Doorn wrote:
> > On Monday 22 September 2008, Xu, Martin wrote:
> > > Hi:
> > > I am the engineer from intel, and we are working on Moblin project(
> > > www.moblin.org). Now we work on eeepc901 platform. The rt2860 wireless
> > > device is used by the platform. We hope the device driver can be
> > > supported in the kernel mainline.
> > > Could you please tell me the states of the device driver? Do you have
> > > schedule on it? 
> > 
> > Nothing has changed since my last announcement to the linux-wireless list
> > regarding the rt2800 drivers.
> > That means that the drivers are not ready, and I have abandonded all schedules
> > which could indicate when the first test version of the driver can be released.
> > 
> > Mattias Nissler has joined the rt2800 development party, so I really hope
> > he has some fresh ideas an how to get the driver development forward again.
> 
> Indeed, I started poking around today. Ivo, do you have version of the
> legacy rt2870 usb driver that compiles and works on recent development
> kernels?

I only managed to compile it on 2.6.25 (but haven't tried hard to get it working
for 2.6.26 and higher), is that recent enough?

Ivo

