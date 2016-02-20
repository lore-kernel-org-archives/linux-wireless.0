Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946154AbcBTBDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 20:03:53 -0500
Date: Fri, 19 Feb 2016 17:03:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, glen.lee@atmel.com, austin.shin@atmel.com,
	Chris.Park@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH V2 01/24] staging: wilc1000: wilc_wlan.c: removes PRINT_ER
Message-ID: <20160220010352.GA10725@kroah.com> (sfid-20160220_020357_490941_32661DC9)
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2016 at 08:30:01PM +0900, Leo Kim wrote:
> This patches removes PRINT_ER that is unnecessary debug logs.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 2 --
>  1 file changed, 2 deletions(-)

What changed in this series from v1?  Why should I take it?

Please resend a v3 that says exactly what differs.

thanks,

greg k-h
