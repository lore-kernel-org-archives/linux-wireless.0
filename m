Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:27171 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753480AbXL1BjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 20:39:25 -0500
Date: Fri, 28 Dec 2007 01:39:24 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071212020325.96dbf41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <463453.24516.qm@web52903.mail.re2.yahoo.com> (sfid-20071228_013931_454098_1CF8F960)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Did any earlier version of the 2.6 kernel work OK?

Kernel 2.6.14 does not work any better than 2.6.23.x, and my F8 userspace environment rejects a
2.4.35 kernel. I will try a 2.6.0 kernel next, but have noticed tonight that a stock Fedora kernel
also hangs when it tries to load the orinoco_plx.ko kernel module. (This module also expect a
PLX9052 bridge.)

For reference, I have found a datasheet for the PLX9052 here:

http://www.dyneng.com/plx_9052.pdf

One theory could be that the PLX9052 chip requires an extra initialisation step for an Intel
SE440BX-2 motherboard (the board that hangs) vs an older Intel Zappa motherboard (where the chip
works OK). However, I don't know anything like enough about PCI to guess what such a step might
be.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

