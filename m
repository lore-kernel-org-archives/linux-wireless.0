Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53689 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZEJVHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 17:07:31 -0400
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
 reorder buffer
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090510202938.GA24197@jm.kir.nu>
References: <20090505173512.349795688@atheros.com>
	 <20090505173550.273830766@atheros.com>
	 <1241709323.4903.25.camel@localhost.localdomain>
	 <1241833703.4903.83.camel@localhost.localdomain>
	 <20090509080838.GA1206@jm.kir.nu>
	 <1241888753.4903.97.camel@localhost.localdomain>
	 <20090510202938.GA24197@jm.kir.nu>
Content-Type: text/plain
Date: Sun, 10 May 2009 14:07:05 -0700
Message-Id: <1241989625.3384.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > from the WPS information element:
> > 
> > 	 * Version: 1.0
> > 	 * Manufacturer: D-Link Systems
> > 	 * Model: DIR-615
> > 	 * Device name: Wireless N Router
> > 	 * Config methods: Label
> > 
> > I bought it over a year ago in Canada. It is actually my second of these
> > since I fried the first one :)
> 
> Thanks! I do actually have a DIR-615. However, it may be completely
> different WLAN chipset depending on the hardware revision (I love the
> vendors who do this..). If you have a chance, could you please take a
> look at which hardware revision your AP is? It is likely in the label on
> the AP (something like "H/W Ver.: D1  F/W Ver.: 4.00).

it is Hardware Version: B2 and Firmware Version: 2.23.

Regards

Marcel


