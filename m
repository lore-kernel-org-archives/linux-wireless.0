Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:38840 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbeBSGht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 01:37:49 -0500
Date: Mon, 19 Feb 2018 12:07:41 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 4/6] staging: wilc1000: fix line over 80 characters in
 wilc_spi_init()
Message-ID: <20180219120741.19232d40@ajaysk-VirtualBox> (sfid-20180219_073754_353158_513F538C)
In-Reply-To: <20180216143022.GA20682@kroah.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
        <1518606615-14404-5-git-send-email-ajay.kathat@microchip.com>
        <20180216143022.GA20682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2018 15:30:22 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> > diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> > index 30a9a61..fddc0db 100644
> > --- a/drivers/staging/wilc1000/wilc_spi.c
> > +++ b/drivers/staging/wilc1000/wilc_spi.c
> > @@ -835,7 +835,6 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
> >  	struct spi_device *spi = to_spi_device(wilc->dev);
> >  	u32 reg;
> >  	u32 chipid;
> > -
> >  	static int isinit;  
> 
> You also deleted this line :(

The blank line was not necessary between the variable's declaration. I
should have done these changes in separate patch.
I will take care to have these type of changes either in a separate patch
or include the change details in description.
