Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9251 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934401AbcISIgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:36:52 -0400
Date: Mon, 19 Sep 2016 10:36:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        kernel-janitors@vger.kernel.org,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcmrvl: constify nfcmrvl_if_ops structures
Message-ID: <20160919083642.GB13777@zurbaran.home> (sfid-20160919_103716_892258_F2BC43C7)
References: <1470762230-2520-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470762230-2520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julia,

On Tue, Aug 09, 2016 at 07:03:50PM +0200, Julia Lawall wrote:
> The nfcmrvl_if_ops structures are never modified, so declare them as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/nfc/nfcmrvl/i2c.c     |    2 +-
>  drivers/nfc/nfcmrvl/main.c    |    2 +-
>  drivers/nfc/nfcmrvl/nfcmrvl.h |    4 ++--
>  drivers/nfc/nfcmrvl/spi.c     |    2 +-
>  drivers/nfc/nfcmrvl/uart.c    |    2 +-
>  drivers/nfc/nfcmrvl/usb.c     |    2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.
