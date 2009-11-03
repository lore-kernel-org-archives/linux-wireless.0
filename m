Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:45600 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753638AbZKCWrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 17:47:51 -0500
Date: Tue, 3 Nov 2009 17:47:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oliver Neukum <oliver@neukum.org>
cc: Dan Williams <dcbw@redhat.com>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	<linux-wireless@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
In-Reply-To: <200911031729.26463.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0911031745010.21065-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 3 Nov 2009, Oliver Neukum wrote:

> > I'm with Matt Dharm and Josua Dietze on this.  Jobs that can be handled
> > in userspace _should_ be handled there.
> 
> There is the inconvenient problem of hibernation. And, if more systems
> start cutting power to USB in STR, the problem of STR. I am inclined
> to declare that hibernation is a problem of those pesky misdesigns.
> But dare we say that also about STR?

If power is turned off, there's nothing we can do about it.  Once that 
happens, it doesn't make much difference whether the mode switch occurs 
in usb-storage or from a userspace program.  The old device instance 
will go away and a new one will appear.

Alan Stern

