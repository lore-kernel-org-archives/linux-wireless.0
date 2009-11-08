Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48837 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZKHMlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:41:44 -0500
Received: by ewy3 with SMTP id 3so2346744ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:41:49 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] rt2x00: fix build of rt2800lib
Date: Sun, 8 Nov 2009 13:25:23 +0100
Cc: IvDoorn@gmail.com, gwingerde@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1257682021-23810-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257682021-23810-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Message-Id: <200911081325.23424.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Could you please tell us more about build problems you have
encountered and which kernel tree this fix is for?

Thanks.

On Sunday 08 November 2009 13:07:01 Hauke Mehrtens wrote:
> rt2x00usb.h uses lots of definitions from linux/usb.h.
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 5c7d74a..b601a1a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -29,6 +29,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/usb.h>
>  
>  #include "rt2x00.h"
>  #ifdef CONFIG_RT2800USB
