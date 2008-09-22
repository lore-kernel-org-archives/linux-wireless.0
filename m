Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753559AbYIVVB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 17:01:58 -0400
Subject: Re: what is the states of rt2800 driver?
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Xu, Martin" <martin.xu@intel.com>, linux-wireless@vger.kernel.org,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>
In-Reply-To: <200809221937.35900.IvDoorn@gmail.com>
References: <200808272222.53719.IvDoorn@gmail.com>
	 <97006967741E44428360DF36A929F3EE01D3F978@pdsmsx415.ccr.corp.intel.com>
	 <200809221937.35900.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 23:01:54 +0200
Message-Id: <1222117314.4670.10.camel@localhost> (sfid-20080922_230220_592484_CAE0E31F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-22 at 19:37 +0200, Ivo van Doorn wrote:
> On Monday 22 September 2008, Xu, Martin wrote:
> > Hi:
> > I am the engineer from intel, and we are working on Moblin project(
> > www.moblin.org). Now we work on eeepc901 platform. The rt2860 wireless
> > device is used by the platform. We hope the device driver can be
> > supported in the kernel mainline.
> > Could you please tell me the states of the device driver? Do you have
> > schedule on it? 
> 
> Nothing has changed since my last announcement to the linux-wireless list
> regarding the rt2800 drivers.
> That means that the drivers are not ready, and I have abandonded all schedules
> which could indicate when the first test version of the driver can be released.
> 
> Mattias Nissler has joined the rt2800 development party, so I really hope
> he has some fresh ideas an how to get the driver development forward again.

Indeed, I started poking around today. Ivo, do you have version of the
legacy rt2870 usb driver that compiles and works on recent development
kernels?

Mattias

