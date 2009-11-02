Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZKBViA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:38:00 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Dan Williams <dcbw@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20091102210519.7d309fb9@lxorguk.ukuu.org.uk>
References: <200910171606.02961.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>
	 <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>
	 <20091102210519.7d309fb9@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 13:37:38 -0800
Message-Id: <1257197858.1027.59.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 21:05 +0000, Alan Cox wrote:
> > apparently do use the driver CD thing to send Linux drivers and software
> > to a few clients.  But by and large, the driver CD is completely
> > useless.
> 
> And then every so often you need to rummage around the driver CD image to
> extract the APN or other data you need to make your modem work. At which
> point you end up having to recompile the kernel to get it. Very annoying
> given it could be trivially done properly in user space.
> 
> HAL probably needs the database of these devices *not* the kernel.

It's udev these days; HAL is going away since it and udev pretty much
can do the same thing anyway.  The tool you're looking for is called
usb_modeswitch, but it needs a bit of work to Just Work in a stock
distro install with the user having to edit a config file.

Dan

