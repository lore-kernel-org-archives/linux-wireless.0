Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:36677 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbYGGVXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:23:11 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:23:09 +0200
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072308.57529.IvDoorn@gmail.com>
In-Reply-To: <200807072308.57529.IvDoorn@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807072323.09177.stefan.bauer@cs.tu-chemnitz.de> (sfid-20080707_232322_645682_21A87420)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 July 2008 23:08:57 you wrote:
> > dmesg 2.6.26-rc9
> > ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> > phy0: Selected rate control algorithm 'pid'
> > phy0: Failed to initialize wep
>
> Check if the arc4 and ecb modules are loaded before loading mac80211 &
> rt2500pci.

They weren't, but loading them before doesn't make any difference.
I've to add that I don't use wep, this WLAN is open.

Regards,
Stefan
