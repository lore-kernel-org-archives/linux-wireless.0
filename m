Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42958 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753625AbZKBVD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:03:56 -0500
Date: Mon, 2 Nov 2009 21:05:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Williams <dcbw@redhat.com>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
Message-ID: <20091102210519.7d309fb9@lxorguk.ukuu.org.uk>
In-Reply-To: <1257193115.1027.24.camel@localhost.localdomain>
References: <200910171606.02961.oliver@neukum.org>
	<Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	<20091017220313.GH24502@one-eyed-alien.net>
	<4ADC3657.6080906@gmx.net>
	<4AEDCCA0.8050709@gmx.net>
	<4AEDD380.40408@draisberghof.de>
	<4AEDEB85.5080105@gmx.net>
	<20091102005144.GE24436@one-eyed-alien.net>
	<4AEF3CAD.10809@gmx.net>
	<1257193115.1027.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> apparently do use the driver CD thing to send Linux drivers and software
> to a few clients.  But by and large, the driver CD is completely
> useless.

And then every so often you need to rummage around the driver CD image to
extract the APN or other data you need to make your modem work. At which
point you end up having to recompile the kernel to get it. Very annoying
given it could be trivially done properly in user space.

HAL probably needs the database of these devices *not* the kernel.

