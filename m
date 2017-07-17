Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdGQQZP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:25:15 -0400
Date: Mon, 17 Jul 2017 18:25:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Gugino <michael.gugino.2@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 1/1] rtl8188eu: add TL-WN722N v2 support
Message-ID: <20170717162510.GE9786@kroah.com> (sfid-20170717_182519_322340_9CFFC63F)
References: <CACHT077fJY0EBYRk+wgnVREoEf-d+Brejq2JngcSpsi_ygV-GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACHT077fJY0EBYRk+wgnVREoEf-d+Brejq2JngcSpsi_ygV-GA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 17, 2017 at 12:03:07PM -0400, Michael Gugino wrote:
> From: Michael Gugino <michael.gugino.2@gmail.com>
> 
> This patch adds support for USB Device TP-Link TL-WN722N v2.
> VendorID: 0x2357, ProductID: 0x010c
> 
> Signed-off-by: Michael Gugino <michael.gugino.2@gmail.com>
> ---
>  drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
>  1 file changed, 1 insertion(+)

What changed from v1?  Always be specific...

v3?
