Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbcALXeU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 18:34:20 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix typo in Kconfig help text
References: <1452601608-11361-1-git-send-email-tklauser@distanz.ch>
Date: Tue, 12 Jan 2016 18:34:19 -0500
In-Reply-To: <1452601608-11361-1-git-send-email-tklauser@distanz.ch> (Tobias
	Klauser's message of "Tue, 12 Jan 2016 13:26:48 +0100")
Message-ID: <wrfjfuy21if8.fsf@redhat.com> (sfid-20160113_003422_488983_EB047239)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klauser <tklauser@distanz.ch> writes:
> Fix spelling of "benefits".
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, I'll put it in my queue.

Jes

>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
> index dd4d626aecbc..8f053c350227 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
> @@ -13,7 +13,7 @@ config RTL8XXXU
>  	  This driver is under development and has a limited feature
>  	  set. In particular it does not yet support 40MHz channels
>  	  and power management. However it should have a smaller
> -	  memory footprint than the vendor drivers and benetifs
> +	  memory footprint than the vendor drivers and benefits
>  	  from the in kernel mac80211 stack.
>  
>  	  It can coexist with drivers from drivers/staging/rtl8723au,
