Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4876 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab0DZToP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:44:15 -0400
Message-ID: <4BD5ED0C.3050506@gmail.com>
Date: Mon, 26 Apr 2010 21:44:12 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800lib: Remove redundant check for RT2872
References: <201004261350.27212.helmut.schaa@googlemail.com>
In-Reply-To: <201004261350.27212.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/10 13:50, Helmut Schaa wrote:
> Remove redundant check for RT2872.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 1358d9a..b30d59c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2018,7 +2018,6 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
>  	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
>  		   rt2x00_rt(rt2x00dev, RT2870) ||
> -		   rt2x00_rt(rt2x00dev, RT2872) ||
>  		   rt2x00_rt(rt2x00dev, RT2872)) {
>  		/*
>  		 * There is a max of 2 RX streams for RT28x0 series

