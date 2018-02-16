Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034401AbeBPOaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 09:30:23 -0500
Date: Fri, 16 Feb 2018 15:30:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 4/6] staging: wilc1000: fix line over 80 characters in
 wilc_spi_init()
Message-ID: <20180216143022.GA20682@kroah.com> (sfid-20180216_153027_576703_F1F315BF)
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
 <1518606615-14404-5-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518606615-14404-5-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 14, 2018 at 04:40:13PM +0530, Ajay Singh wrote:
> Modified wilc_spi_init() to fix the line over 80 char issues reported
> by checkpatch.pl script.
> To overcome the checkpatch.pl reported issue modified debug logs and
> comments used in wilc_spi_init().
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 30a9a61..fddc0db 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -835,7 +835,6 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
>  	struct spi_device *spi = to_spi_device(wilc->dev);
>  	u32 reg;
>  	u32 chipid;
> -
>  	static int isinit;

You also deleted this line :(
