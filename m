Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757101AbZKDRHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:07:21 -0500
Date: Wed, 4 Nov 2009 12:07:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Frank Schaefer <schaefer.frank@gmx.net>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
In-Reply-To: <1257351909.28469.97.camel@johannes.local>
Message-ID: <Pine.LNX.4.44L0.0911041204540.2968-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 4 Nov 2009, Johannes Berg wrote:

> On Wed, 2009-11-04 at 11:16 -0500, Alan Stern wrote:
> 
> > Here's my first attempt at considering all the pros and cons.  Has
> > anything important been left out?
> 
> [snip]
> 
> I think you forgot to consider the case where both the driver and the
> mode switch code need an update to handle a new device. This is relevant
> in the case where a new device shows up that needs mode-switching, but
> even after switching has an ID that the current driver doesn't know
> about.

This could be handled by programs like usb_modeswitch.  The USB serial 
drivers allow IDs to be added dynamically.

Of course, if something more than that is required then the situation 
would be different.  However I think this is pretty rare.

Alan Stern

