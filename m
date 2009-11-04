Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:56401 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZKDJbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 04:31:39 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Wed, 4 Nov 2009 10:11:38 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0911032255190.25039-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911032255190.25039-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911041011.38367.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 4. November 2009 04:57:59 schrieb Alan Stern:
> On Wed, 4 Nov 2009, Oliver Neukum wrote:
> > > If power is turned off, there's nothing we can do about it.  Once that
> > > happens, it doesn't make much difference whether the mode switch occurs
> > > in usb-storage or from a userspace program.  The old device instance
> > > will go away and a new one will appear.
> >
> > That is what happens and what must happen if we switch mode in user
> > space. In kernel space, the kernel could repeat the mode switch.
>
> How?  Doesn't the mode switch cause a change in the configuration,
> interface, or endpoint descriptors?  The end result would be the same
> -- the old device instance would go away and a new one would appear.

But it switches to a known state which we could use to trigger a switch
and recompare after the switch.

	Regards
		Oliver

