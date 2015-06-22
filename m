Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbbFVSYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 14:24:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Joglekar\, Tejas \(T.\)" <tjogleka@visteon.com>
Cc: "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging:rtl8723au:odm.c:Removing trailing whitespaces
References: <20150620124603.GA3311@Tejas-asus>
Date: Mon, 22 Jun 2015 14:24:00 -0400
In-Reply-To: <20150620124603.GA3311@Tejas-asus> (Tejas Joglekar's message of
	"Sat, 20 Jun 2015 12:46:16 +0000")
Message-ID: <wrfjfv5j38lb.fsf@redhat.com> (sfid-20150622_202407_630714_545B3113)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Joglekar, Tejas (T.)" <tjogleka@visteon.com> writes:
> From: Joglekar Tejas <tjogleka@visteon.com>
>
> This patch removes the trailing whitespace error given
> by checkpatch.pl
>
> Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
> ---
>  drivers/staging/rtl8723au/hal/odm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks straight forward.

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Jes


> diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
> index f354f5e..6b9dbef 100644
> --- a/drivers/staging/rtl8723au/hal/odm.c
> +++ b/drivers/staging/rtl8723au/hal/odm.c
> @@ -985,7 +985,7 @@ void ODM_RF_Saving23a(struct dm_odm_t *pDM_Odm, u8 bForceInNormal)
>  			val32 = rtl8723au_read32(adapter, 0x874);
>  			val32 |= pDM_PSTable->Reg874;
>  			rtl8723au_write32(adapter, 0x874, val32);
> -		
> +
>  			val32 = rtl8723au_read32(adapter, 0xc70);
>  			val32 |= pDM_PSTable->RegC70;
>  			rtl8723au_write32(adapter, 0xc70, val32);
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
