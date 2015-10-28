Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbbJ1Xs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 19:48:26 -0400
Date: Thu, 29 Oct 2015 08:48:23 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 04/12] staging: wilc1000: wilc_wlan_txq_add_mgmt_pkt: add
 new argument dev
Message-ID: <20151028234823.GA4982@kroah.com> (sfid-20151029_004829_164180_58CB8E40)
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
 <1446018508-17889-4-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446018508-17889-4-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 04:48:20PM +0900, Glen Lee wrote:
> This patch adds new argument struct net_device *dev and pass argument
> struct net_device to the function.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_mon.c              | 2 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
>  drivers/staging/wilc1000/wilc_wlan.c              | 3 ++-
>  drivers/staging/wilc1000/wilc_wlan.h              | 4 ++--
>  4 files changed, 7 insertions(+), 6 deletions(-)

Doesn't apply, please rebase and resend this whole series.

thanks,

greg k-h
