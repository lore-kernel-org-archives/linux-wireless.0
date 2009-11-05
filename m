Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53580 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbZKESl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:59 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 07/41] rt2x00: fix rt2x00usb_register_read() comment
Date: Thu, 5 Nov 2009 19:42:02 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051942.03123.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_register_read() comment
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -232,7 +232,7 @@ static inline int rt2x00usb_eeprom_read(
>  }
>  
>  /**
> - * rt2x00usb_regbusy_read - Read 32bit register word
> + * rt2x00usb_register_read - Read 32bit register word
>   * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
>   * @offset: Register offset
>   * @value: Pointer to where register contents should be stored
> 


