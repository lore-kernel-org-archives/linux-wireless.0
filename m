Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0147.outbound.protection.outlook.com ([157.56.112.147]:60864
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755080AbcBDFPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 00:15:36 -0500
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"austin.shin@atmel.com" <austin.shin@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"tony.cho@atmel.com" <tony.cho@atmel.com>,
	"glen.lee@atmel.com" <glen.lee@atmel.com>,
	"leo.kim@atmel.com" <leo.kim@atmel.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Move Macro definition
Date: Thu, 4 Feb 2016 05:00:33 +0000
Message-ID: <20160204050143.GB9343@IND12F0122> (sfid-20160204_061553_017864_9434AC29)
References: <20160118134339.GA16263@IND12F0122>
 <20160203231950.GA6765@kroah.com>
In-Reply-To: <20160203231950.GA6765@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 03, 2016 at 03:19:50PM -0800, gregkh@linuxfoundation.org wrote:
> On Mon, Jan 18, 2016 at 01:42:35PM +0000, Gujulan Elango, Hari Prasath (H.) wrote:
> > From: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> > 
> > This patch move's a macro defined in the middle of a structure
> > definition to make it more readable.
> > 
> > Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> > ---
> >  drivers/staging/wilc1000/wilc_sdio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> > index e961b50..875ea68 100644
> > --- a/drivers/staging/wilc1000/wilc_sdio.c
> > +++ b/drivers/staging/wilc1000/wilc_sdio.c
> > @@ -29,12 +29,12 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
> >  };
> >  
> >  #define WILC_SDIO_BLOCK_SIZE 512
> > +#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
> >  
> >  typedef struct {
> >  	bool irq_gpio;
> >  	u32 block_size;
> >  	int nint;
> > -#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
> 
> No, this is a very common way to show that this define is for this field
> in the structure, please don't change that.
> 
> sorry,
> 
> greg k-h

Thanks Greg,I got the message clear.Please discard this patch.
Regards,
Hari