Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:32942 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031985Ab0B1UdU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 15:33:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Date: Sun, 28 Feb 2010 21:33:10 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <201002281958.12607.mb@bu3sch.de> <20100228203038.456b9016@boulder.homenet>
In-Reply-To: <20100228203038.456b9016@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002282133.10981.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 February 2010 21:30:38 Chris Vine wrote:
> On Sun, 28 Feb 2010 19:58:11 +0100
> Michael Buesch <mb@bu3sch.de> wrote:
> > It says 8k for all of my devices there. So an MMIO write to 0x2000
> > and above writes to completely random memory.
> > 
> My BCM4312 device is 16K:
> 
>   Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]

Ok, then this write is _clearly_ not to be done unconditionally.

-- 
Greetings, Michael.
