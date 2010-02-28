Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:48860 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032025Ab0B1Uu2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 15:50:28 -0500
Message-ID: <4B8AD742.9000201@polymtl.ca>
Date: Sun, 28 Feb 2010 15:51:14 -0500
From: William Bourque <william.bourque@polymtl.ca>
MIME-Version: 1.0
To: Chris Vine <chris@cvine.freeserve.co.uk>
CC: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>	<b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com>	<69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>	<201002281958.12607.mb@bu3sch.de> <20100228203038.456b9016@boulder.homenet>
In-Reply-To: <20100228203038.456b9016@boulder.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chris Vine wrote:
> On Sun, 28 Feb 2010 19:58:11 +0100
> Michael Buesch <mb@bu3sch.de> wrote:
>> It says 8k for all of my devices there. So an MMIO write to 0x2000
>> and above writes to completely random memory.
>>
> My BCM4312 device is 16K:
> 
>   Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]


Now that you mention it, mine as well :

01:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)
         Subsystem: Hewlett-Packard Company Device 1507
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at feafc000 (64-bit, non-prefetchable) [size=16K]

Are all the failing devices have a 16k mem space?

- William
