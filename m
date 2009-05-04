Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:37395 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZEDWfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 18:35:20 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1092431eyd.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 15:35:19 -0700 (PDT)
Date: Tue, 5 May 2009 00:49:52 +0200
From: Tulio Magno Quites Machado Filho <tuliom@quites.com.br>
To: Alf <alf@mypals.org>, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
Message-ID: <20090504224952.GB9342@joutaro.lan>
References: <200905021218.23747.alf@mypals.org> <1241298894.13562.28.camel@johannes.local> <200905021553.55173.alf@mypals.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200905021553.55173.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On May 02 09 15:53, Alf wrote:
> Also, this is what lspci reports:
> 00:07.0 Ethernet controller: Atheros Communications Inc. AR2413 802.11bg NIC 
> (rev 01)
>         Subsystem: D-Link System Inc D-Link AirPlus G DWL-G510 Wireless PCI 
> Adapter(rev.B)
>         Flags: bus master, medium devsel, latency 96, IRQ 18
>         Memory at e0120000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [44] Power Management version 2
> 
> Does anyone know if this card is supported?  Anybody know why this card 
> works sometimes but most of the time it can't associate with the AP?

I think so (http://wireless.kernel.org/en/users/Drivers/ath5k#supportedchips).

Have you tried Johannes sugestion?

-- 
Tulio Magno

