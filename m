Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305AbcBCXeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:34:06 -0500
Date: Wed, 3 Feb 2016 15:34:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, glen.lee@atmel.com, austin.shin@atmel.com,
	Chris.Park@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 1/7] staging: wilc1000: wilc_wfi_cfgoperations.c:
 replaces PRINT_ER with netdev_err
Message-ID: <20160203233406.GA20695@kroah.com> (sfid-20160204_003413_153613_2F4E4895)
References: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2016 at 11:11:19AM +0900, Leo Kim wrote:
> This patches replaces PRINT_ER with netdev_err.
> Removes unnecessary debug logs as well.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 86 ++++++++---------------
>  1 file changed, 31 insertions(+), 55 deletions(-)

This series didn't apply either :(
