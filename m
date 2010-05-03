Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ip84.de ([212.122.42.5]:56286 "EHLO bart.ip84.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715Ab0ECPUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 11:20:48 -0400
From: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
Date: Mon, 3 May 2010 17:20:36 +0200
References: <201005031624.45409.rain_maker@root-forum.org> <20100503145815.GA24781@tuxdriver.com>
In-Reply-To: <20100503145815.GA24781@tuxdriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201005031720.36288.rain_maker@root-forum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Monday 03 May 2010 16:58:16 schrieben Sie:
> I also get more than 100 hits from (probably the same) well-known
> search engine for "rt73usb_init_eeprom: Error - Invalid RT chipset
> detected".  I'm sure those aren't all for the same USB ID, and perhaps
> none of them are.  Then again, not all of the 1500+ that you cite
> are for the same USB ID either.

Well, of course I can't be 100% sure, I had this patch "in storage" for a long 
time and already applied it so some packages I build, but hesitated for quite 
a while if I should submit it.

Additionally, the search string was not too good, it would have been better to 
cite this one here

148f:2573 rt2500usb_init_eeprom: Error

(about 500 hits)

>
> So I'm curious, how can you be sure that 148f:2573 is _always_ wrong
> for rt2500usb?  I do acknowledge that the "73" part makes it suspicious...
>

As I am active in several fora and read quite a few more, I stumbled over this 
annoyance (as I said it is not a fatal error) for several times in the past 
few months/years and in all cases I know rt73usb was the working driver.

But of course the problem in such cases is, you can't prove it, you can only 
add more and more examples for "not being wrong" while finding one example 
where actually a device with 148f:2573 working with rt2500usb und not working 
with rt73usb would prove me wrong once and for all.

Best wishes,

Axel K
