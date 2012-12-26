Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42639 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab2LZKkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 05:40:22 -0500
Message-ID: <50DAD40E.7040000@hauke-m.de> (sfid-20121226_114029_327706_E40F833E)
Date: Wed, 26 Dec 2012 11:40:14 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH][3.8?] bcma: correct M25P32 serial flash ID
References: <1356471262-9242-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1356471262-9242-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/25/2012 10:34 PM, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

I already saw a bug report on the OpenWrt mailing list because of this
problem:
http://permalink.gmane.org/gmane.comp.embedded.openwrt.devel/16944

> ---
> John: it's trivial, you may want to take it for fixes (3.8).
> I leave it up to you. Noticed it while working on ssb.
> ---
>  drivers/bcma/driver_chipcommon_sflash.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
> index 63e6883..1e694db 100644
> --- a/drivers/bcma/driver_chipcommon_sflash.c
> +++ b/drivers/bcma/driver_chipcommon_sflash.c
> @@ -35,7 +35,7 @@ static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
>  	{ "M25P40", 0x12, 0x10000, 8, },
>  
>  	{ "M25P16", 0x14, 0x10000, 32, },
> -	{ "M25P32", 0x14, 0x10000, 64, },
> +	{ "M25P32", 0x15, 0x10000, 64, },
>  	{ "M25P64", 0x16, 0x10000, 128, },
>  	{ "M25FL128", 0x17, 0x10000, 256, },
>  	{ 0 },
> 

