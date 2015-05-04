Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:38727 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbEDJPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 05:15:21 -0400
Message-ID: <55473869.8010904@atmel.com> (sfid-20150504_111523_905021_021A400C)
Date: Mon, 4 May 2015 11:14:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
MIME-Version: 1.0
To: Johnny Kim <johnny.kim@atmel.com>, <gregkh@linuxfoundation.org>,
	<linux-wireless@vger.kernel.org>
CC: <chris.park@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>
Subject: Re: [PATCH v2 2/2] staging: MAINTAINERS: add maintainer for wilc1000
 device
References: <90c05bda434a068796547a599e8ea5e3ad3acb21.1430301575.git.johnny.kim@atmel.com> <0c403fce8ae243edb21419cc2840195a94f829ee.1430301575.git.johnny.kim@atmel.com>
In-Reply-To: <0c403fce8ae243edb21419cc2840195a94f829ee.1430301575.git.johnny.kim@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 29/04/2015 14:50, Johnny Kim a écrit :
> Add myself as maintainer for atmel wilc1000
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> Signed-off-by: Rachel Kim <rachel.kim@atmel.com>
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> Signed-off-by: Chris Park <chris.park@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks!

> ---
> Changes in v2:
> - fix the permissions
> - fix the folder tree
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1b8263c..2ddf38c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9473,6 +9473,16 @@ M:	Forest Bond <forest@alittletooquiet.net>
>  S:	Odd Fixes
>  F:	drivers/staging/vt665?/
>  
> +STAGING - WILC1000 WIFI DRIVER
> +M:	Johnny Kim <johnny.kim@atmel.com>
> +M:	Rachel Kim <rachel.kim@atmel.com>
> +M:	Dean Lee <dean.lee@atmel.com>
> +M:	Chris Park <chris.park@atmel.com>
> +L:	devel@driverdev.osuosl.org
> +L:	linux-wireless@vger.kernel.org
> +S:	Supported
> +F:	drivers/staging/wilc1000/
> +
>  STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
>  M:	Arnaud Patard <arnaud.patard@rtp-net.org>
>  S:	Odd Fixes
> 


-- 
Nicolas Ferre
