Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbbIPUSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 16:18:55 -0400
Date: Wed, 16 Sep 2015 23:18:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aparna Karuthodi <kdasaparna@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Removed unwanted curly braces
Message-ID: <20150916201847.GA4953@mwanda> (sfid-20150916_221919_257818_55F31463)
References: <1442420450-5760-1-git-send-email-kdasaparna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442420450-5760-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2015 at 09:50:50PM +0530, Aparna Karuthodi wrote:
> Removed unwanted curly braces of a single statement if-else block to
> remove a coding style warning detected by checkpatch. The warning is
> given below:
> 
> 58: WARNING: braces {} are not necessary for any arm of this statement
> 
> Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
> ---
>  drivers/staging/wilc1000/fifo_buffer.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/fifo_buffer.c b/drivers/staging/wilc1000/fifo_buffer.c
> index b6c07cf..4fbac3d 100644
> --- a/drivers/staging/wilc1000/fifo_buffer.c
> +++ b/drivers/staging/wilc1000/fifo_buffer.c
> @@ -52,11 +52,10 @@ u32 FIFO_ReadBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToRead, u32 *pu32By
>  		if (pstrFifoHandler->u32TotalBytes) {
>  			down(&pstrFifoHandler->SemBuffer);
>  
> -			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes) {
> +			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes)
>  				*pu32BytesRead = pstrFifoHandler->u32TotalBytes;
> -			} else {
> +			 else

The indenting is wrong here.  There is an extra space char.

regards,
dan carpenter

