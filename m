Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53402 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYKMPlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 10:41:55 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Update file authorship in comments
Date: Thu, 13 Nov 2008 13:42:10 -0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <491b6768.iqQUkTGJLrREsFyl%Larry.Finger@lwfinger.net>
In-Reply-To: <491b6768.iqQUkTGJLrREsFyl%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811131342.10504.herton@mandriva.com.br> (sfid-20081113_164157_626197_0C32CE8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 November 2008 21:31:52 Larry Finger wrote:
> Modify the file comments to reflect the current maintainers.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

> 
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -7,6 +7,11 @@
>   * Based on the r8187 driver, which is:
>   * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
>   *
> + * The driver was extended to the RTL8187B in 2008 by:
> + * 	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> + *	Hin-Tak Leung <htl10@users.sourceforge.net>
> + *	Larry Finger <Larry.Finger@lwfinger.net>
> + *
>   * Magic delays and register offsets below are taken from the original
>   * r8187 driver sources.  Thanks to Realtek for their support!
>   *
> @@ -27,6 +32,9 @@
>  
>  MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
>  MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
> +MODULE_AUTHOR("Herton Ronaldo Krzesinski <herton@mandriva.com.br>");
> +MODULE_AUTHOR("Hin-Tak Leung <htl10@users.sourceforge.net>");
> +MODULE_AUTHOR("Larry Finger <Larry.Finger@lwfinger.net>");
>  MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
>  MODULE_LICENSE("GPL");
> 
>  
> 

-- 
[]'s
Herton
