Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:46454 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754159AbXGZISU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 04:18:20 -0400
Message-ID: <46A858BB.3090402@debian.org>
Date: Thu, 26 Jul 2007 11:18:03 +0300
From: Faidon Liambotis <paravoid@debian.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.23 1/3] [wireless] Kconfig: order options
References: <20070722131636.GA2967@void.cube.gr>
In-Reply-To: <20070722131636.GA2967@void.cube.gr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Faidon Liambotis wrote:
> Reorder the Atmel options so that the menu appears saner.
> Before:
>   < >   Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)
>   <*>   Atmel at76c50x chipset  802.11b support
>   < >     Atmel at76c506 PCI cards (NEW)
>   < > Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards
>   < > Atmel at76c502/at76c504 PCMCIA cards (NEW)
> 
> After:
>   < >   Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)
>   <*>   Atmel at76c50x chipset  802.11b support
>   < >     Atmel at76c506 PCI cards (NEW)
>   < >     Atmel at76c502/at76c504 PCMCIA cards (NEW)
>   < >   Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards

This was posted as a series because they depend on each other.

However, Pavel's NAK about the more intrusive change on orinoco 
shouldn't block the other two which very much stand.

They are trivial but useful, please apply.

Regards,
Faidon
