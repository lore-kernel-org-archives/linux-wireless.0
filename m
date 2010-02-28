Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:58920 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032041Ab0B1UzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 15:55:06 -0500
Date: Sun, 28 Feb 2010 20:54:58 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: William Bourque <william.bourque@polymtl.ca>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Message-ID: <20100228205458.3e06dd35@boulder.homenet>
In-Reply-To: <4B8AD742.9000201@polymtl.ca>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	<b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com>
	<69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>
	<201002281958.12607.mb@bu3sch.de>
	<20100228203038.456b9016@boulder.homenet>
	<4B8AD742.9000201@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 28 Feb 2010 15:51:14 -0500
William Bourque <william.bourque@polymtl.ca> wrote:
> Chris Vine wrote:
> > On Sun, 28 Feb 2010 19:58:11 +0100
> > Michael Buesch <mb@bu3sch.de> wrote:
> >> It says 8k for all of my devices there. So an MMIO write to 0x2000
> >> and above writes to completely random memory.
> >>
> > My BCM4312 device is 16K:
> > 
> >   Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
> 
> 
> Now that you mention it, mine as well :
> 
> 01:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g
> (rev 01) Subsystem: Hewlett-Packard Company Device 1507
>          Flags: bus master, fast devsel, latency 0, IRQ 16
>          Memory at feafc000 (64-bit, non-prefetchable) [size=16K]
> 
> Are all the failing devices have a 16k mem space?

And with 64-bit layout?  (Michael's was 32-bit.)

Chris


