Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:49448 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaJCOlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 10:41:16 -0400
Message-ID: <542EB589.7020909@hauke-m.de> (sfid-20141003_164119_367098_4FE7D1D7)
Date: Fri, 03 Oct 2014 16:41:13 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH][RFC] bcma: fill core details for every device
References: <1412246303-18172-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1412246303-18172-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2014 12:38 PM, Rafał Miłecki wrote:
> We were setting things like dma_dev, IRQ, etc. during core registration
> only. We need such info for cores handled internally (e.g. ChipCommon)
> as well.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

I already was preparing a patch doing similar things but this one looks
better.

> ---
>  drivers/bcma/bcma_private.h | 1 +
>  drivers/bcma/main.c         | 9 ++++++---
>  drivers/bcma/scan.c         | 1 +
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 

