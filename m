Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55592 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXLMBRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 20:17:47 -0500
Subject: Re: BCM4306 Questions
From: Pavel Roskin <proski@gnu.org>
To: Randy Cushman <rcushman_linux@roadrunner.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <47608102.5010105@roadrunner.com>
References: <475F2DAD.4000708@roadrunner.com>
	 <200712121214.50522.mb@bu3sch.de> <475FCB46.2030209@roadrunner.com>
	 <200712121300.59811.mb@bu3sch.de>  <47608102.5010105@roadrunner.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 20:17:44 -0500
Message-Id: <1197508664.13188.27.camel@dv> (sfid-20071213_011755_968896_A028EC34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Wed, 2007-12-12 at 19:46 -0500, Randy Cushman wrote:
> Michael Buesch wrote:
> > Not at all.
> > You have to read the webpage. Here's the link again:
> > http://www.linuxwireless.org/en/users/Drivers/b43#devicefirmware
> > Everything is described there.
> >
> >   
> Thank you for being patient with me.
> 
> When I read that web page for the fourth time, I finally realized that 
> what I needed to do was forget about using the correct driver for my 
> adapter, and instead download an ancient driver for an unidentified 
> adapter from a website of unknown authenticity, and use the firmware 
> from that driver instead.  Should have been obvious, I guess.

I have looked at that page, and I don't see anything confusing there.  I
wish I could improve it, but I don't see how.

The firmware checksum is verified, so either you are getting the right
firmware, or you are not getting any.

There is no talk of choosing "the correct driver".  Instead, the page
suggests downloading both firmwares rather than guessing:

"If you are unsure and don't know what we are talking about here, always
build both b43 and b43legacy (and get firmware for both too). The kernel
autoloader will automatically do the right thing and load the correct
driver for your device."

-- 
Regards,
Pavel Roskin
