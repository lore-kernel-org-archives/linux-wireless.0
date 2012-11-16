Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37629 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2KPSYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 13:24:50 -0500
Message-ID: <1353090250.10872.83.camel@cumari.coelho.fi> (sfid-20121116_192453_545458_8184B956)
Subject: Re: [PATCH 2/2] wlcore: SPI - fix spi transfer_list
From: Luciano Coelho <coelho@ti.com>
To: <Janusz.Dziedzic@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <arik@wizery.com>
Date: Fri, 16 Nov 2012 20:24:10 +0200
In-Reply-To: <3078A9B976EF864C8DDD0C499FFD07912383D647A0@EXMB01.eu.tieto.com>
References: <3078A9B976EF864C8DDD0C499FFD07912383D647A0@EXMB01.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 15:42 +0200, Janusz.Dziedzic@tieto.com wrote:
> In corner case for wl12xx_spi_raw_write() when
> 	len == SPI_AGGR_BUFFER_SIZE
> we don't setup correctly spi transfer_list.
> Next we will have garbage and strange errors
> reported by SPI framework (eg. wrong speed_hz,
> failed to transfer one message from queue)
> when iterate transfer_list.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---

Thanks for trying out the SPI support on our driver! And, even better,
fixing it! :)

Applied and pushed.

--
Luca.

