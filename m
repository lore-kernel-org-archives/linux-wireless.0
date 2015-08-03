Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbbHCPoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 11:44:10 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Ting-Chih Hsiao <s894330@hotmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix up coding style warnings reported by checkpatch.pl.
References: <BLU437-SMTP740B6DF13FC4BBDF43D824B9770@phx.gbl>
Date: Mon, 03 Aug 2015 11:44:08 -0400
In-Reply-To: <BLU437-SMTP740B6DF13FC4BBDF43D824B9770@phx.gbl> (Ting-Chih
	Hsiao's message of "Mon, 3 Aug 2015 11:57:34 +0800")
Message-ID: <wrfjoaioe5rr.fsf@carbonite.lan.trained-monkey.org> (sfid-20150803_174414_063549_24F7C92B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ting-Chih Hsiao <s894330@hotmail.com> writes:
> remove spaces at the start of a line
> align enum variable with other parameters
>
> Signed-off-by: Ting-Chih Hsiao <s894330@hotmail.com>
> ---
>  drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> index 342dec3..a63c6cb 100644
> --- a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> +++ b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
> @@ -21,7 +21,7 @@ odm_ConfigRFReg_8723A(
>  	struct dm_odm_t *pDM_Odm,
>  	u32					Addr,
>  	u32					Data,
> -  enum RF_RADIO_PATH     RF_PATH,
> +	enum RF_RADIO_PATH     RF_PATH,
>  	u32				    RegAddr
>  	)
>  {

Patch looks fine, but remember to always CC devel@driverdev.osuosl.org
on staging patches.

Jes
