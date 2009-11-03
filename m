Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbZKCAyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 19:54:32 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Dan Williams <dcbw@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20091102223903.4378e0fa@lxorguk.ukuu.org.uk>
References: <200910171606.02961.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>
	 <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>
	 <20091102211123.GI24436@one-eyed-alien.net>
	 <1257198124.1027.63.camel@localhost.localdomain>
	 <20091102223903.4378e0fa@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 16:54:07 -0800
Message-Id: <1257209647.18754.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 22:39 +0000, Alan Cox wrote:
> > Maybe we can get the kernel drivers to expose the information we need
> > (maybe even an 'eject' attribute in sysfs or something) and then we just
> > have to write udev rules instead of having a whole bunch of libusb junk
> > in userspace?  Would that preserve the policy-always-in-userspace
> > requirement yet keep the code to drive the hardware in kernel space
> > where it really belongs?
> 
> Or put the magic strings in the kernel with a translation hook for the
> eject request ? That would keep policy and method in the right places.
> You ask the kernel to eject, it hides the magic weirdness.

Yes, that would be awesome.

Dan

