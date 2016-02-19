Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35644 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992562AbcBSAlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 19:41:08 -0500
Received: by mail-ig0-f173.google.com with SMTP id hb3so24993585igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2016 16:41:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455795024-26978-18-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com> <1455795024-26978-18-git-send-email-leo.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 19 Feb 2016 11:40:47 +1100
Message-ID: <CAGRGNgXJD1Cu1CdmYZfhqf=Up_v0pA2zw+GthDtJPaVwuV99JQ@mail.gmail.com> (sfid-20160219_014114_193892_74664BA4)
Subject: Re: [PATCH V2 18/24] staging: wilc1000: linux_wlan.c: removes
 unnecessary log messages
To: Leo Kim <leo.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <Chris.Park@atmel.com>,
	"Abozaeid, Adham" <adham.abozaeid@atmel.com>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Leo,

On Thu, Feb 18, 2016 at 10:30 PM, Leo Kim <leo.kim@atmel.com> wrote:
> From: Chris Park <chris.park@atmel.com>
>
> This patch removes unnecessary log messages.
>
> Signed-off-by: Chris Park <chris.park@atmel.com>
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index a731b46..660bf63 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -226,7 +226,6 @@ static void deinit_irq(struct net_device *dev)
>
>  void wilc_dbg(u8 *buff)
>  {
> -       PRINT_D(INIT_DBG, "%d\n", *buff);
>  }

Are you sure this is right? If so, why not just remove this function entirely?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
