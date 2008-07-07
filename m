Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52229 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756301AbYGGV1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:27:20 -0400
From: Stefan Bauer <stefan-a-bauer@gmx.net>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:27:17 +0200
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807072327.17714.stefan-a-bauer@gmx.net> (sfid-20080707_232727_118818_771335A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 7. Juli 2008 schrieb Stefan Bauer:

> dmesg 2.6.26-rc9
> ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> phy0: Selected rate control algorithm 'pid'
> phy0: Failed to initialize wep
> phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> rt2500pci: probe of 0000:00:0c.0 failed with error -12
>
> .config 2.6.26-rc9
> <http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config>
>
> Next I'm going to test 2.6.24 and 2.6.25 to check whether it's an
> regression or not.

Same problem with 2.6.24.7, I'll skip 2.6.25.


Regards, Stefan
