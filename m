Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbcBCX25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:28:57 -0500
Date: Wed, 3 Feb 2016 15:28:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 04/13] staging: wilc1000: rename hWILCWFIDrv of wilc_priv
 structure
Message-ID: <20160203232856.GA4498@kroah.com> (sfid-20160204_002904_001977_1A2D84BE)
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
 <1453863037-31073-4-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453863037-31073-4-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2016 at 11:50:28AM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch renames hWILCWFIDrv pointer variable of wilc_priv structure
> to hif_drv to avoid camelcase.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c             |  8 ++++----
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 ++++++++++++----------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
>  3 files changed, 17 insertions(+), 15 deletions(-)

This patch didn't apply, so I stopped here in the series.  Please fix up
and resend.

thanks,

greg k-h
