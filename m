Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:60717 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZKHPTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 10:19:16 -0500
Received: by ey-out-2122.google.com with SMTP id 25so14216eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 07:19:20 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Update copyright statements.
Date: Sun, 8 Nov 2009 16:18:00 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>
References: <1257692976-2036-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257692976-2036-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911081618.00917.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 16:09:36 Gertjan van Wingerde wrote:
> As mentioned on the linux-wireless mailing list, the current copyright statements in the rt2x00 are
> meaningless, as the rt2x00 project is not even a formal legal entity. Therefore it is better to replace
> the existing copyright statements with copyright statements for the people that actually wrote the code.
> 
> Note: Updated to the best of my knowledge with respect to who contributed considerable amounts of code.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: Ivo van Doorn <IvDoorn@gmail.com>
> CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 5c7d74a..aed72a9 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1,10 +1,15 @@
>  /*
> -	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
> -
> -	Based on the original rt2800pci.c and rt2800usb.c:
> -
> -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
> -	  <http://rt2x00.serialmonkey.com>
> +	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> +	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
> +	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
> +	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
> +	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
> +	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
> +	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
> +	<http://rt2x00.serialmonkey.com>
> +
> +	Based on the original rt2800pci.c and rt2800usb.c.

NAK

See my other mail.  You are trying to reverse the history now.
