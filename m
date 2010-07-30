Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48579 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0G3UIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 16:08:17 -0400
From: "Gabay, Benzy" <benzyg@ti.com>
To: Andreas Feuersinger <andreas.feuersinger@spintower.eu>
CC: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jul 2010 15:08:06 -0500
Subject: RE: MX27 libertas_sdio SDIO Interrupts vs available bitrate
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C1311499C43@dlee04.ent.ti.com>
References: <20100729124604.79f88553@speedy>
In-Reply-To: <20100729124604.79f88553@speedy>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Andreas Feuersinger
> Sent: Thursday, July 29, 2010 5:46 AM
> To: libertas-dev@lists.infradead.org; linux-mmc@vger.kernel.org; linux-
> wireless@vger.kernel.org
> Subject: MX27 libertas_sdio SDIO Interrupts vs available bitrate
> 
> 
> Hi,
> 
> I'm trying to improve throughput of the Marvell 8686 sdio wlan module.
> Unfortunately I have to stick with kernel 2.6.22.
> 
> Everything works except for very bad datarate. So far the mxc_mmc
> driver does not handle any SDIO interrupts. Could that be the reason
> for the bad performance?
> 
> 
> I figured, it does not make any difference wheter I use DMA for data
> transfer or not (odd?)
If interrupts are not handled in MMC level and you are disabling DMA operation how then will the transfer completion is handled in that case?


> 
> I get only up to 90K/s.
> 
> 
> thanks!
> 
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers
      Benzy Gabay
