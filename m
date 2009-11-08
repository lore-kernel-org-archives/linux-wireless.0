Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40804 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZKHMhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:37:38 -0500
Received: by ewy3 with SMTP id 3so2345053ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:37:43 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] rt2x00: fix build of rt2800lib
Date: Sun, 8 Nov 2009 13:37:21 +0100
Cc: gwingerde@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, bzolnier@gmail.com
References: <1257682021-23810-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257682021-23810-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081337.21713.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Hauke Mehrtens wrote:
> rt2x00usb.h uses lots of definitions from linux/usb.h.

rt2800lib should not depend on either PCI or USB,
so which defines from usb.h are used in rt2x00lib.c?

Ivo

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


