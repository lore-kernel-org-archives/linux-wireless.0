Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65265 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2GIPD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 11:03:59 -0400
Received: by qcro28 with SMTP id o28so6734582qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 08:03:58 -0700 (PDT)
Message-ID: <4FFAF2D8.3070505@lwfinger.net> (sfid-20120709_170403_029660_41E150C4)
Date: Mon, 09 Jul 2012 10:03:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: realtek drivers
References: <1341844078-2319-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1341844078-2319-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 09:27 AM, Xose Vazquez Perez wrote:
> s/RTL8192CE/RTLWIFI , add wiki pages and delete
> "F:     drivers/net/wireless/rtlwifi/rtl8192ce/", it's redundant.
>
> ---
>   MAINTAINERS |    9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 03df1d1..5c27b0c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5753,7 +5753,7 @@ F:	net/rose/
>   RTL8180 WIRELESS DRIVER
>   M:	"John W. Linville" <linville@tuxdriver.com>
>   L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl8187
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>   S:	Maintained
>   F:	drivers/net/wireless/rtl818x/rtl8180/
> @@ -5763,20 +5763,19 @@ M:	Herton Ronaldo Krzesinski <herton@canonical.com>
>   M:	Hin-Tak Leung <htl10@users.sourceforge.net>
>   M:	Larry Finger <Larry.Finger@lwfinger.net>
>   L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl8187
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>   S:	Maintained
>   F:	drivers/net/wireless/rtl818x/rtl8187/
>
> -RTL8192CE WIRELESS DRIVER
> +RTLWIFI WIRELESS DRIVERS

NACK on this part. Rather than removing rtl8192ce, it should be kept. The new 
line should be

RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE, AND RTL8192DE WIRELESS DRIVERS

Larry

>   M:	Larry Finger <Larry.Finger@lwfinger.net>
>   M:	Chaoming Li <chaoming_li@realsil.com.cn>
>   L:	linux-wireless@vger.kernel.org
> -W:	http://linuxwireless.org/
> +W:	http://linuxwireless.org/en/users/Drivers/rtl819x
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>   S:	Maintained
>   F:	drivers/net/wireless/rtlwifi/
> -F:	drivers/net/wireless/rtlwifi/rtl8192ce/
>
>   S3 SAVAGE FRAMEBUFFER DRIVER
>   M:	Antonino Daplas <adaplas@gmail.com>
>


