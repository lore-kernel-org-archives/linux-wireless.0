Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbcA2SAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 13:00:42 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
References: <20160129172908.GA14077@Karyakshetra>
Date: Fri, 29 Jan 2016 13:00:40 -0500
In-Reply-To: <20160129172908.GA14077@Karyakshetra> (Bhaktipriya Shridhar's
	message of "Fri, 29 Jan 2016 22:59:08 +0530")
Message-ID: <wrfjk2ms465z.fsf@redhat.com> (sfid-20160129_190100_021179_CEC0C950)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
> This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
> WARNING: void function return statements are not generally useful
>
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> index d28f29a..e8a16b9 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> @@ -2657,7 +2657,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)
>
>  	dump_mgntframe23a(padapter, pmgntframe);
>
> -	return;
>  }

If you insist on pushing this rather unncessary change, please do it
properly, and remove the blank line before the return statement as well.

Jes
