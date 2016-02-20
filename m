Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1948676AbcBTBGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 20:06:15 -0500
Date: Fri, 19 Feb 2016 17:06:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/6] staging: wilc1000: removes wilc_dbg()
Message-ID: <20160220010615.GB15749@kroah.com> (sfid-20160220_020620_772748_47D30D9B)
References: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2016 at 05:37:07PM +0900, Leo Kim wrote:
> This patch removes wilc_dbg function because it's not any more.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c         | 4 ----
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 --
>  drivers/staging/wilc1000/wilc_wlan.c          | 2 --
>  3 files changed, 8 deletions(-)

I didn't apply the other series, so I can't apply this one, please
resend this after fixing it up as part of the other series.

thanks,

greg k-h
