Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63045 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2DRUo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 16:44:29 -0400
Received: by pbcun15 with SMTP id un15so9387722pbc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 13:44:29 -0700 (PDT)
Date: Wed, 18 Apr 2012 13:44:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: Re: [PATCH v5 0/4] USB: OHCI/EHCI: generic platform driver
Message-ID: <20120418204424.GA20171@kroah.com> (sfid-20120418_224434_409760_FF553A9B)
References: <1331851799-5968-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331851799-5968-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 11:49:55PM +0100, Hauke Mehrtens wrote:
> This EHCI/OHCI platform driver should replace the simple EHCI and OHCI 
> platform drivers. It was developed to be used for the USB core of the 
> Broadcom SoCs supported by ssb and bcma, but it should also work for 
> other devices.
> 
> Drivers like ehci-ath79.c, ehci-xls.c and ehci-ixp4xx.c should be 
> relative easy be ported to this EHCI driver.
> And drivers like ohci-ath79.c, ohci-ppc-soc.c, ohci-sh.c and ohci-xls.c 
> should be easy be ported to the this OHCI driver.
> 
> I am unable to test the suspend and resume part, as my SoC does not 
> support this, but most of the platform driver do not support 
> suspend/resume too. The code here should work, but was never runtime 
> tested.
> 
> This also contains patches adding USB support for the SoCs based on ssb 
> and bcma and converts the ath79 code to use the generic usb driver.
> 
> This patch series is based on the usb tree and should go through it to Linus.

All now applied, thanks.

greg k-h
