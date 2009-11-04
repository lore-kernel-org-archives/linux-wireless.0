Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:47160 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752937AbZKDD5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 22:57:55 -0500
Date: Tue, 3 Nov 2009 22:57:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oliver Neukum <oliver@neukum.org>
cc: Dan Williams <dcbw@redhat.com>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	<linux-wireless@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
In-Reply-To: <200911040055.01441.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0911032255190.25039-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 4 Nov 2009, Oliver Neukum wrote:

> > If power is turned off, there's nothing we can do about it.  Once that
> > happens, it doesn't make much difference whether the mode switch occurs
> > in usb-storage or from a userspace program.  The old device instance
> > will go away and a new one will appear.
> 
> That is what happens and what must happen if we switch mode in user space.
> In kernel space, the kernel could repeat the mode switch.

How?  Doesn't the mode switch cause a change in the configuration,
interface, or endpoint descriptors?  The end result would be the same 
-- the old device instance would go away and a new one would appear.

Alan Stern

