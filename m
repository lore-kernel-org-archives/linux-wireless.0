Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:32787 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZKHNvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:51:39 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2376683ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:51:45 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 3/9] rt2800pci: add missing RF values to rf_vals table
Date: Sun, 8 Nov 2009 14:51:43 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133909.23584.32892.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133909.23584.32892.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081451.43639.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add missing RF values to rf_vals table
> 
> rt2800pci's rf_vals[] copy was missing values for some channels.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1158,6 +1158,10 @@ static const struct rf_channel rf_vals[]
>  	{ 159, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed1a7 },
>  	{ 161, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed187 },
>  	{ 165, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed197 },
> +	{ 167, 0x18402ec4, 0x184c03d2, 0x18179855, 0x1815531f },
> +	{ 169, 0x18402ec4, 0x184c03d2, 0x18179855, 0x18155327 },
> +	{ 171, 0x18402ec4, 0x184c03d6, 0x18179855, 0x18155307 },
> +	{ 173, 0x18402ec4, 0x184c03d6, 0x18179855, 0x1815530f },
>  
>  	/* 802.11 Japan */
>  	{ 184, 0x15002ccc, 0x1500491e, 0x1509be55, 0x150c0a0b },
> 


