Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbcBCX0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:26:46 -0500
Date: Wed, 3 Feb 2016 15:26:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: Re: [PATCH V2 15/26] staging: wilc1000: wilc_set_wfi_drv_handler:
 add mac index
Message-ID: <20160203232646.GA20738@kroah.com> (sfid-20160204_002652_446280_6AFA9C34)
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
 <1453707330-13526-16-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453707330-13526-16-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2016 at 04:35:19PM +0900, Glen Lee wrote:
> Firmware supports sta/ap concurrency so mac index will be passed to wilc.
> Remove wilc_set_wfi_drv_handler in scan and connect functions, and call
> the function in ndo_open which is wilc_mac_open.
> WID_SET_DRV_HANDLER value has been changed as well.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
> Changes in V2:
>  - fix checkpatch CHECK: space prefferred around that '^'

This patch fails to apply, so can you refresh the rest of the series and
resend it?  I've applied the first 14 patches here.

thanks,

greg k-h
