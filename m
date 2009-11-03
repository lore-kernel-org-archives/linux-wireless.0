Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:39532 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZKCXwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 18:52:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Wed, 4 Nov 2009 00:55:01 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0911031745010.21065-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911031745010.21065-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911040055.01441.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 3. November 2009 23:47:55 schrieb Alan Stern:
> On Tue, 3 Nov 2009, Oliver Neukum wrote:
> > > I'm with Matt Dharm and Josua Dietze on this.  Jobs that can be handled
> > > in userspace _should_ be handled there.
> >
> > There is the inconvenient problem of hibernation. And, if more systems
> > start cutting power to USB in STR, the problem of STR. I am inclined
> > to declare that hibernation is a problem of those pesky misdesigns.
> > But dare we say that also about STR?
>
> If power is turned off, there's nothing we can do about it.  Once that
> happens, it doesn't make much difference whether the mode switch occurs
> in usb-storage or from a userspace program.  The old device instance
> will go away and a new one will appear.

That is what happens and what must happen if we switch mode in user space.
In kernel space, the kernel could repeat the mode switch.

	Regards
		Oliver

