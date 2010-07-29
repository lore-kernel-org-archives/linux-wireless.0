Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep34.mx.upcmail.net ([62.179.121.52]:59602 "EHLO
	fep34.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0G2Kva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 06:51:30 -0400
Date: Thu, 29 Jul 2010 12:46:04 +0200
From: Andreas Feuersinger <andreas.feuersinger@spintower.eu>
To: libertas-dev@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: MX27 libertas_sdio SDIO Interrupts vs available bitrate
Message-ID: <20100729124604.79f88553@speedy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I'm trying to improve throughput of the Marvell 8686 sdio wlan module.
Unfortunately I have to stick with kernel 2.6.22.

Everything works except for very bad datarate. So far the mxc_mmc
driver does not handle any SDIO interrupts. Could that be the reason
for the bad performance? 


I figured, it does not make any difference wheter I use DMA for data
transfer or not (odd?)

I get only up to 90K/s.


thanks!

Andreas
