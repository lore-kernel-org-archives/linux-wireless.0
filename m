Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbKDUvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:51:36 -0500
Date: Wed, 4 Nov 2015 12:51:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/38] staging: wilc1000: rename pu8IPAddr of fuction
 Handle_set_IPAddress
Message-ID: <20151104205134.GA24488@kroah.com> (sfid-20151104_215139_120036_FDBFABD2)
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2015 at 05:50:44PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch renames pu8IPAddr of fuction Handle_set_IPAddress to ip_addr
> to avoid CamelCase naming convention.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

This series doesn't apply probably because I didn't take your previous
series.  Please resend after you refresh and resend that one.

thanks,

greg k-h
