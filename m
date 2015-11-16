Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:61142 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbbKPOFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: glen lee <glen.lee@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/20] staging/wilc1000: pass hif operations through initialization
Date: Mon, 16 Nov 2015 15:05:41 +0100
Message-ID: <4322239.PAt56lqfM0@wuerfel> (sfid-20151116_150815_358649_0C09D143)
In-Reply-To: <5649332F.3020901@atmel.com>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de> <4443486.3C2xMnGSPO@wuerfel> <5649332F.3020901@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 16 November 2015 10:36:47 glen lee wrote:
> On 2015년 11월 13일 18:17, Arnd Bergmann wrote:
> > On Friday 13 November 2015 16:49:22 glen lee wrote:
> >> Hi arnd,
> >>
> >> I found this. These should be like this. It works fine.
> >> +       .hif_block_tx_ext = sdio_write,
> >> +       .hif_block_rx_ext = sdio_read,
> >>
> >> also, wilc_hif_spi need to be fixed together like this.
> >> +       .hif_block_tx_ext = _wilc_spi_write,
> >> +       .hif_block_rx_ext = _wilc_spi_read,
> >>
> >> Thank you for all the patches.
> >>
> > Glad you found it. How should we go on to get the right version merged?
> > Do you want to send the working version of my patches to Greg along with
> > whatever you have on your end, or do you prefer me to re-send it?
> 
> In my opinion, why don't you re-send the whole patches again since I'm still working on.
> 

Ok, done.

	Arnd
