Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbJHKF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 06:05:29 -0400
Date: Thu, 8 Oct 2015 10:57:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 1/6] staging: wilc1000: remove typedef from
 tstrWILC_WFIDrv
Message-ID: <20151008095738.GA32258@kroah.com> (sfid-20151008_120620_921669_EB5101D9)
References: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 05, 2015 at 07:28:09PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes typedef from the struct tstrWILC_WFIDrv and
> rename it to host_if_drv.
> This patch includes the removal of the comment for tstrWILC_WFIDrv as well.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c         | 362 +++++++++++-----------
>  drivers/staging/wilc1000/host_interface.h         | 108 +++----
>  drivers/staging/wilc1000/linux_wlan.c             |  16 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  24 +-
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   4 +-
>  5 files changed, 253 insertions(+), 261 deletions(-)

This patch fails to apply :(

Please rebase and resend the whole series.

thanks,

greg k-h
