Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44504 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037Ab0ECPAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 11:00:11 -0400
Date: Mon, 3 May 2010 10:58:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
Message-ID: <20100503145815.GA24781@tuxdriver.com>
References: <201005031624.45409.rain_maker@root-forum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201005031624.45409.rain_maker@root-forum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 03, 2010 at 04:24:45PM +0200, rain_maker@root-forum.org wrote:
> The drivers rt2500usb and rt73usb both contain the usb id 148f:2573 while only 
> the latter is suitable for devices with that id.
> 
> As a consequence, both drivers will be loaded and system log shows messages 
> like "rt2500usb_init_eeprom: Error - Invalid RT chipset detected".
> 
> If you use the above search term, you will find more than 1500 hits with a 
> well known search engine, confirming that rt2500usb is always the wrong 
> driver for devices with usb id 148f:2573 and quite often as a side effect 
> confusion arose about this -non fatal but misleading- error message in the 
> respective bug reports or threads.

I also get more than 100 hits from (probably the same) well-known
search engine for "rt73usb_init_eeprom: Error - Invalid RT chipset
detected".  I'm sure those aren't all for the same USB ID, and perhaps
none of them are.  Then again, not all of the 1500+ that you cite
are for the same USB ID either.

So I'm curious, how can you be sure that 148f:2573 is _always_ wrong
for rt2500usb?  I do acknowledge that the "73" part makes it suspicious...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
