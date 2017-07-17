Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdGQQYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:24:03 -0400
Date: Mon, 17 Jul 2017 18:23:57 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Gugino <michael.gugino.2@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] rtl8188eu: add TL-WN722N v2 support
Message-ID: <20170717162357.GD9786@kroah.com> (sfid-20170717_182406_681391_36787CF4)
References: <CACHT076KPRRyt5KuEOKkjGSh+wrQAFOEzcPx2-ZHfbp=6u9aTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACHT076KPRRyt5KuEOKkjGSh+wrQAFOEzcPx2-ZHfbp=6u9aTQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 17, 2017 at 11:59:35AM -0400, Michael Gugino wrote:
> From: Michael Gugino <michael.gugino.2@gmail.com>
> 
> This patch adds support for USB Device TP-Link TL-WN722N v2.
> VendorID: 0x2357, ProductID: 0x010c
> 
> Signed-off-by: Michael Gugino <michael.gugino.2@gmail.com>
> ---
> drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
> 1 file changed, 1 insertion(+)

You just sent two different patches, with the same subject, and both
were corrupted :(

Please fix your email client (test it by sending it to yourself first),
and try again.

Also, use scripts/get_maintainer.pl to get the correct mailing list...

thanks,

greg k-h
