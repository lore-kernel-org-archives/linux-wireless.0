Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbbJWP5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 11:57:18 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_wlan_util: fix misleading indentation
References: <1445448758-28794-1-git-send-email-luisbg@osg.samsung.com>
Date: Fri, 23 Oct 2015 11:57:15 -0400
In-Reply-To: <1445448758-28794-1-git-send-email-luisbg@osg.samsung.com> (Luis
	de Bethencourt's message of "Wed, 21 Oct 2015 18:32:38 +0100")
Message-ID: <wrfjr3klefxg.fsf@redhat.com> (sfid-20151023_175722_266990_2016D07C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis de Bethencourt <luisbg@osg.samsung.com> writes:
> For loop is outside of the else branch of the above conditional statement.
> Fixing misleading indentation.
>
> Fix a smatch warning:
> drivers/staging/rtl8723au/core/rtw_wlan_util.c:528
> WMMOnAssocRsp23a() warn: curly braces intended?
>
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_wlan_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> index 5e87360..cc2b84b 100644
> --- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> @@ -525,7 +525,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
>  	else
>  		aSifsTime = 16;
>  
> -		for (i = 0; i < 4; i++) {
> +	for (i = 0; i < 4; i++) {
>  		ACI = (pmlmeinfo->WMM_param.ac_param[i].ACI_AIFSN >> 5) & 0x03;
>  		ACM = (pmlmeinfo->WMM_param.ac_param[i].ACI_AIFSN >> 4) & 0x01;
