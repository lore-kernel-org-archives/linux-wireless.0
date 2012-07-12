Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45624 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2GLTde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 15:33:34 -0400
Date: Thu, 12 Jul 2012 15:16:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] MAINTAINERS: realtek drivers
Message-ID: <20120712191645.GC25494@tuxdriver.com> (sfid-20120712_213406_106415_3DC36037)
References: <1341855212-7151-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341855212-7151-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch doesn't apply...

On Mon, Jul 09, 2012 at 07:33:32PM +0200, Xose Vazquez Perez wrote:
> s/RTL8192CE/RTLWIFI , add wiki pages and delete
> "F:     drivers/net/wireless/rtlwifi/rtl8192ce/", it's redundant.
> 
> v2 s/RTL8192CE/RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE AND RTL8192DE
> 
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> Cc: John W. Linville <linville@tuxdriver.com>
> ---
>  MAINTAINERS |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 03df1d1..27de053 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5753,7 +5753,7 @@ F:	net/rose/
>  RTL8180 WIRELESS DRIVER
>  M:	"John W. Linville" <linville@tuxdriver.com>
>  L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl8187
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>  S:	Maintained
>  F:	drivers/net/wireless/rtl818x/rtl8180/
> @@ -5763,20 +5763,19 @@ M:	Herton Ronaldo Krzesinski <herton@canonical.com>
>  M:	Hin-Tak Leung <htl10@users.sourceforge.net>
>  M:	Larry Finger <Larry.Finger@lwfinger.net>
>  L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl8187
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>  S:	Maintained
>  F:	drivers/net/wireless/rtl818x/rtl8187/
>  
> -RTL8192CE WIRELESS DRIVER
> +RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE AND RTL8192DE WIRELESS DRIVERS
>  M:	Larry Finger <Larry.Finger@lwfinger.net>
>  M:	Chaoming Li <chaoming_li@realsil.com.cn>
>  L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl819x
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>  S:	Maintained
>  F:	drivers/net/wireless/rtlwifi/
> -F:	drivers/net/wireless/rtlwifi/rtl8192ce/
>  
>  S3 SAVAGE FRAMEBUFFER DRIVER
>  M:	Antonino Daplas <adaplas@gmail.com>
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
