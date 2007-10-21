Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57757 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXJUUEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 16:04:52 -0400
Date: Sun, 21 Oct 2007 22:04:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	mwallis@serialmonkey.com
Subject: ISSC W89C35 802.11bg (was Re: rt73usb: support for wireless in
	Kohjinsha subnotebook)
Message-ID: <20071021200457.GA29024@elf.ucw.cz> (sfid-20071021_210455_524051_5AD3645D)
References: <20071020184100.GA11640@elf.ucw.cz> <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> This device is NOT a Ralink USB wifi adapter!
> 
> Get the windows driver in this link and see for yourself.
> http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))

You are right, sorry for confusion.

Now, the strange part comes. They have linux sources on their web
pages... for 2.6.9 and 2.6.11. If anyone ported them forward, please
let me know, otherwise I'll take a look at porting them.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
