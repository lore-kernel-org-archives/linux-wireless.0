Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:22487 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYGGVgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:36:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so698572nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:36:06 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:44:07 +0200
Cc: Stefan Bauer <stefan-a-bauer@gmx.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072327.17714.stefan-a-bauer@gmx.net>
In-Reply-To: <200807072327.17714.stefan-a-bauer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807072344.07580.IvDoorn@gmail.com> (sfid-20080707_233612_591060_9309801D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 July 2008, Stefan Bauer wrote:
> Am Montag, 7. Juli 2008 schrieb Stefan Bauer:
> 
> > dmesg 2.6.26-rc9
> > ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> > phy0: Selected rate control algorithm 'pid'
> > phy0: Failed to initialize wep
> > phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> > rt2500pci: probe of 0000:00:0c.0 failed with error -12
> >
> > .config 2.6.26-rc9
> > <http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config>
> >
> > Next I'm going to test 2.6.24 and 2.6.25 to check whether it's an
> > regression or not.
> 
> Same problem with 2.6.24.7, I'll skip 2.6.25.

What happens when you compile ecb and arc4 into the kernel
instead as seperate modules?

Ivo
