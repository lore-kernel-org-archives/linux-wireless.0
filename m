Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55678 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab0CJUap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:45 -0500
Date: Wed, 10 Mar 2010 15:16:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, Vasanth.Thiagarajan@Atheros.com,
	Senthilkumar.Balasubramanian@Atheros.com,
	luis.rodrigues@atheros.com
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
Message-ID: <20100310201609.GB3093@tuxdriver.com>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19336.46643.733555.555640@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2010 at 11:35:39AM +0530, Sujith wrote:
> Support for AR9271 chipset.
> 
> Features:
> 
>  * Station mode
>  * IBSS mode
>  * Monitor mode
>  * Legacy support
>  * HT support
>  * TX/RX 11n Aggregation
>  * HW encryption
>  * LED
> 
> For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

So I got the impression from another thread that Atheros is hoping
to get this merged into the 2.6.34 stream, presumably under the
idea that this is a new driver.  But this doesn't just add files,
it makes a few changes to existing ath9k files (i.e. not just Kconfig
and/or Makefile).

Are you hoping to see this in 2.6.34?  Why don't those other bits
matter?  How can you be sure that they don't destabilize ath9k for
_anyone_?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
