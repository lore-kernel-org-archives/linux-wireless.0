Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:42282 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAUVuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jan 2018 16:50:32 -0500
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix trailing semicolon
To: Luis de Bethencourt <luisbg@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20180117105622.3717-1-luisbg@kernel.org>
Message-ID: <05242a57-777f-cf88-b985-1c30a564cb95@gmail.com> (sfid-20180121_225055_471723_E6967978)
Date: Sun, 21 Jan 2018 16:50:26 -0500
MIME-Version: 1.0
In-Reply-To: <20180117105622.3717-1-luisbg@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2018 05:56 AM, Luis de Bethencourt wrote:
> The trailing semicolon is an empty statement that does no operation.
> Removing it since it doesn't do anything.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
> ---
> 
> Hi,
> 
> After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
> suggested I fix it treewide [0].
> 
> Best regards 
> Luis
> 
> 
> [0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
> [1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html
> 
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>


> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 95e3993d8a33..8828baf26e7b 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1172,7 +1172,7 @@ struct rtl8723bu_c2h {
>  
>  			u8 basic_rate:1;
>  			u8 bt_has_reset:1;
> -			u8 dummy4_1:1;;
> +			u8 dummy4_1:1;
>  			u8 ignore_wlan:1;
>  			u8 auto_report:1;
>  			u8 dummy4_2:3;
> 
