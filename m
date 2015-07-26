Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbbGZNA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 09:00:26 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Joglekar\, Tejas \(T.\)" <tjogleka@visteon.com>
Cc: "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au:core:rtw_sreset.c:Fix for space related error
References: <20150726074009.GA14066@tejas-asus.domain.name>
Date: Sun, 26 Jul 2015 09:00:23 -0400
In-Reply-To: <20150726074009.GA14066@tejas-asus.domain.name> (Tejas Joglekar's
	message of "Sun, 26 Jul 2015 07:40:51 +0000")
Message-ID: <wrfjd1zful94.fsf@redhat.com> (sfid-20150726_150043_134642_36674A73)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Joglekar, Tejas (T.)" <tjogleka@visteon.com> writes:
> From: Joglekar Tejas <tjogleka@visteon.com>
>
> This patch fixes the error given by checkpatch.pl
>
> Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_sreset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_sreset.c b/drivers/staging/rtl8723au/core/rtw_sreset.c
> index 29a29d9..48b7723 100644
> --- a/drivers/staging/rtl8723au/core/rtw_sreset.c
> +++ b/drivers/staging/rtl8723au/core/rtw_sreset.c
> @@ -71,7 +71,7 @@ static void sreset_restore_security_station(struct rtw_adapter *padapter)
>  			/* pairwise key */
>  			rtw_setstakey_cmd23a(padapter, (unsigned char *)psta, true);
>  			/* group key */
> -			rtw_set_key23a(padapter,&padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
> +			rtw_set_key23a(padapter, &padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
>  		}
>  	}
>  }

NAK!

If you are 'fixing' checkpatch 'errors', do it properly and break down
the line and solve the 80 character limit 'error' as well.

Jes
