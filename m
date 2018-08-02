Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbeHBJXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 05:23:11 -0400
Date: Thu, 2 Aug 2018 09:33:17 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 3/8] staging: wilc1000: remove unnecessary copyright
 information in file
Message-ID: <20180802073317.GA14107@kroah.com> (sfid-20180802_093323_057453_7447A36F)
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
 <1532844417-3192-4-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1532844417-3192-4-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 29, 2018 at 11:36:52AM +0530, Ajay Singh wrote:
> Cleanup patch to remove the unnecessary copyright information in
> the file, as it already has SPDX License Identifier.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_debugfs.c  | 10 ----------
>  drivers/staging/wilc1000/wilc_sdio.c     |  5 -----
>  drivers/staging/wilc1000/wilc_spi.c      |  5 -----
>  drivers/staging/wilc1000/wilc_wlan_cfg.c |  8 --------
>  drivers/staging/wilc1000/wilc_wlan_cfg.h |  8 --------
>  5 files changed, 36 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
> index ac26e94..d86f457 100644
> --- a/drivers/staging/wilc1000/wilc_debugfs.c
> +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> @@ -1,14 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0
> -/*
> - * NewportMedia WiFi chipset driver test tools - wilc-debug
> - * Copyright (c) 2012 NewportMedia Inc.
> - * Author: SSW <sswd@wilcsemic.com>

No, you can not just drop copyright lines for no reason at all.  Did
your lawyers approve this patch?

SPDX identifes the _license_ of the file, not the copyrights, so it is
ok to drop these lines:

> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.

As that is what it is replacing.  But not the copyrights.

Go show your lawyer this patch:

> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -1,9 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) Atmel Corporation.  All rights reserved.

And see what they do :)

(yes, explicit copyright notices are really not needed and do not do
"much", but it is still the norm that they are present and our industry
does still rely on them...)

thanks,

greg k-h
