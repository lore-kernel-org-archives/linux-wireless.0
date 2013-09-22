Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42545 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab3IVFfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 01:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VNcJz-0006rh-5g
	for linux-wireless@vger.kernel.org; Sun, 22 Sep 2013 07:35:04 +0200
Received: from cpe-69-76-174-198.kc.res.rr.com ([cpe-69-76-174-198.kc.res.rr.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 07:35:03 +0200
Received: from calcprogrammer1 by cpe-69-76-174-198.kc.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 07:35:03 +0200
To: linux-wireless@vger.kernel.org
From: Adam Honse <calcprogrammer1@gmail.com>
Subject: Re: brcmsmac causes soft lockup in 3.12-rc1
Date: Sun, 22 Sep 2013 05:33:29 +0000 (UTC)
Message-ID: <loom.20130922T072315-740@post.gmane.org> (sfid-20130922_073533_709181_98C2409F)
References: <20130921223440.GA5297@mail.catnarok.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having the same issues on my laptop.  Under Debian, Ubuntu, and Arch I
had the same problem in every kernel release I tried brcmsmac on in that the
range is very poor.  My router in the basement was intermittent upstairs in
the room directly above the router, and got barely enough signal to work
reliably sitting next to it.  I just switched the machine back to Ubuntu
(GNOME Remix) today to test the Radeon drivers but upon installing 3.12 I'm
getting the same soft-lockup bug, crashes the whole PC before I can log in
and even see what's going on.  The closed source Broadcom STA driver works
fine on supported kernels.

Laptop is an HP dv6z-7000 with:

AMD A10-4600 APU / Radeon 7660G
Radeon 7730M
Broadcom BCM4313

Ubuntu GNOME Remix 13.10 daily, up to date
Linux 3.11.0 from main repos (working, poor signal)
Linux 3.12-rc1 from Ubuntu kernel PPA (crashes, CPU #1 lockup)

The machine has Bluetooth as well and I don't know if that's part of the
BCM4313 or not.  hciconfig says that hci0 is on Bus: USB while the 4313 is
on PCI according to lspci, but if it uses both buses on the same mini-PCIe
card I don't know.

I can provide other files if necessary.

Thanks,
Adam

