Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbcBCXTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:19:51 -0500
Date: Wed, 3 Feb 2016 15:19:50 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
Cc: "johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"austin.shin@atmel.com" <austin.shin@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"tony.cho@atmel.com" <tony.cho@atmel.com>,
	"glen.lee@atmel.com" <glen.lee@atmel.com>,
	"leo.kim@atmel.com" <leo.kim@atmel.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Move Macro definition
Message-ID: <20160203231950.GA6765@kroah.com> (sfid-20160204_002024_767458_66D246F9)
References: <20160118134339.GA16263@IND12F0122>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160118134339.GA16263@IND12F0122>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2016 at 01:42:35PM +0000, Gujulan Elango, Hari Prasath (H.) wrote:
> From: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> 
> This patch move's a macro defined in the middle of a structure
> definition to make it more readable.
> 
> Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index e961b50..875ea68 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -29,12 +29,12 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
>  };
>  
>  #define WILC_SDIO_BLOCK_SIZE 512
> +#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
>  
>  typedef struct {
>  	bool irq_gpio;
>  	u32 block_size;
>  	int nint;
> -#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */

No, this is a very common way to show that this define is for this field
in the structure, please don't change that.

sorry,

greg k-h
