Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41180 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759362AbZKFPye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 10:54:34 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N6R90-00009s-5X
	for linux-wireless@vger.kernel.org; Fri, 06 Nov 2009 16:54:39 +0100
Received: from host204-255-dynamic.1-87-r.retail.telecomitalia.it ([87.1.255.204])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 16:54:34 +0100
Received: from carlo_parata by host204-255-dynamic.1-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 16:54:34 +0100
To: linux-wireless@vger.kernel.org
From: Carlo Parata <carlo_parata@hotmail.com>
Subject: Re: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k driver)
Date: Fri, 6 Nov 2009 15:54:11 +0000 (UTC)
Message-ID: <loom.20091106T165330-596@post.gmane.org>
References: <loom.20091106T135746-452@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carlo Parata <carlo_parata@...> writes:

> 
> With this patch, a Acer Aspire One D250 can turn on the wifi led. The array of
> compatible devices in ath5k driver now includes the hardware present in this
> computer, as well as the led pin and polarity.
> 
> --- ../led.c	2009-11-06 06:16:39.000000000 +0100
> +++ ./drivers/net/wireless/ath/ath5k/led.c	2009-11-06 12:37:44.000000000 +0100
> @@ -73,6 +73,8 @@
>  	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
>  	/* IBM-specific AR5212 (all others) */
>  	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
> +        /* Acer Aspire One D250 AR5007EG */
> +	{ PCI_VDEVICE(ATHEROS, 0x001c), ATH_LED(3, 1) },
>  	{ }
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Excuse me but it is the first post for me in this mailing list.
How can I find out the subdevice of my wireless card?
The device specifications shown by Windows XP are:

PCI\VEN_168C&DEV_001C&SUBSYS_E00D105B&REV_01\4&192AC53F&0&00E0

Thanks

