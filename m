Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33668 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZEJU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 16:29:57 -0400
Date: Sun, 10 May 2009 23:29:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
	reorder buffer
Message-ID: <20090510202938.GA24197@jm.kir.nu>
References: <20090505173512.349795688@atheros.com> <20090505173550.273830766@atheros.com> <1241709323.4903.25.camel@localhost.localdomain> <1241833703.4903.83.camel@localhost.localdomain> <20090509080838.GA1206@jm.kir.nu> <1241888753.4903.97.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241888753.4903.97.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 09, 2009 at 10:05:53AM -0700, Marcel Holtmann wrote:

> from the WPS information element:
> 
> 	 * Version: 1.0
> 	 * Manufacturer: D-Link Systems
> 	 * Model: DIR-615
> 	 * Device name: Wireless N Router
> 	 * Config methods: Label
> 
> I bought it over a year ago in Canada. It is actually my second of these
> since I fried the first one :)

Thanks! I do actually have a DIR-615. However, it may be completely
different WLAN chipset depending on the hardware revision (I love the
vendors who do this..). If you have a chance, could you please take a
look at which hardware revision your AP is? It is likely in the label on
the AP (something like "H/W Ver.: D1  F/W Ver.: 4.00).

-- 
Jouni Malinen                                            PGP id EFC895FA
