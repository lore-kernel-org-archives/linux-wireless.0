Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.freeserve.com ([193.252.22.191]:27242 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032025Ab0B1Uax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 15:30:53 -0500
Date: Sun, 28 Feb 2010 20:30:38 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Message-ID: <20100228203038.456b9016@boulder.homenet>
In-Reply-To: <201002281958.12607.mb@bu3sch.de>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	<b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com>
	<69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>
	<201002281958.12607.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 28 Feb 2010 19:58:11 +0100
Michael Buesch <mb@bu3sch.de> wrote:
> It says 8k for all of my devices there. So an MMIO write to 0x2000
> and above writes to completely random memory.
> 
My BCM4312 device is 16K:

  Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]

Chris


