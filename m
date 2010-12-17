Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50357 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab0LQTR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:17:26 -0500
Message-ID: <4D0BB739.3020700@hauke-m.de>
Date: Fri, 17 Dec 2010 20:17:13 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8192ce: Update MAINTAINERS
References: <4d0a2c91.Nuemy+kBaD1fOuX+%Larry.Finger@lwfinger.net>
In-Reply-To: <4d0a2c91.Nuemy+kBaD1fOuX+%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 04:13 PM, Larry Finger wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/MAINTAINERS
> ===================================================================
> --- wireless-testing.orig/MAINTAINERS
> +++ wireless-testing/MAINTAINERS
> @@ -5055,6 +5055,16 @@ T:	git git://git.kernel.org/pub/scm/linu
>  S:	Maintained
>  F:	drivers/net/wireless/rtl818x/rtl8187*
>  
> +RTL8192CE WIRELESS DRIVER
> +M:	Larry Finger <Larry.Finger@lwfinger.net>
> +M:	Chaoming Li <chaoming_li@realsil.com.cn>
> +L:	linux-wireless@vger.kernel.org
> +W:	http://linuxwireless.org/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> +S:	Maintained
> +F:	drivers/net/wireless/rtlwifi/
> +F:	drivers/net/wireless/rtl8192ce/
This path is wrong, it should be drivers/net/wireless/rtlwifi/rtl8192ce/
at least the driver is not in rivers/net/wireless/rtl8192ce/.

Hauke
