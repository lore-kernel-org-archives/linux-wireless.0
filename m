Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39976 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbZGANRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 09:17:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43: Add support for 4318E
Date: Wed, 1 Jul 2009 15:17:41 +0200
Cc: John W Linville <linville@tuxdriver.com>, ccmcphe@verizon.net,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a4ada70.t85pybsO8xH4owyV%Larry.Finger@lwfinger.net>
In-Reply-To: <4a4ada70.t85pybsO8xH4owyV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907011517.41572.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 July 2009 05:39:28 Larry Finger wrote:
> From: Clyde McPherson <ccmcphe@verizon.net>
> 
> Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
> 4318E can do 802.11A/B/G, only B and G mode are supported in b43.
> 
> Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

ack

> ---
> 
> diff --git a/drivers/net/wireless/b43/pcmcia.c 
> b/drivers/net/wireless/b43/pcmcia.c
> index 3cfc303..6c3a749 100644
> --- a/drivers/net/wireless/b43/pcmcia.c
> +++ b/drivers/net/wireless/b43/pcmcia.c
> @@ -35,6 +35,7 @@
>  
>  static /*const */ struct pcmcia_device_id b43_pcmcia_tbl[] = {
>  	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
> +	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
>  	PCMCIA_DEVICE_NULL,
>  };
> 
> 
> 



-- 
Greetings, Michael.
