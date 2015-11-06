Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbKFWpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 17:45:23 -0500
Date: Fri, 6 Nov 2015 14:45:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/26] staging: wilc1000: separate hif_sdio and hif_spi
 into different module
Message-ID: <20151106224522.GA22199@kroah.com> (sfid-20151106_234526_860569_45F719CF)
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
 <1446802823-22598-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446802823-22598-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2015 at 06:39:58PM +0900, Glen Lee wrote:
> hif_sdio and hif_spi objects are compiled all the time even though one of SPI
> or SDIO is selected. This patch separates hif_sdio and hif_spi into different
> modules using ifdef define.
> After rework SPI and SDIO modules with only one hif interface, the define
> WILC_SDIO will be removed. This is first path of this series.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/Makefile    |  6 +++---
>  drivers/staging/wilc1000/wilc_wlan.c | 36 +++++++++++++++++-------------------
>  2 files changed, 20 insertions(+), 22 deletions(-)

This patch doesn't apply at all, I think we are out of sync now.  Please
refresh and redo this series against my staging-testing branch and
resend.

thanks,

greg k-h
