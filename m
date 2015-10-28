Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbbJ1XqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 19:46:22 -0400
Date: Thu, 29 Oct 2015 08:46:19 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 18/80] staging: wilc1000: rename au8AssociatedBSSID of
 struct host_if_drv
Message-ID: <20151028234619.GA27684@kroah.com> (sfid-20151029_004625_651365_7A2463E6)
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
 <1446015640-29398-18-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446015640-29398-18-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 03:59:38PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch renames au8AssociatedBSSID of struct host_if_drv to assoc_bssid
> to avoid CamelCase naming convention.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 8 ++++----
>  drivers/staging/wilc1000/host_interface.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

Doesn't apply as I didn't take patch 17 for the obvious reason.  Please
fix up and resend the series of what I didn't take.

thanks,

greg k-h
