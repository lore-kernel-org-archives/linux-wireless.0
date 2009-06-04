Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:34454 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZFDPkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 11:40:47 -0400
Message-ID: <4A27EB7A.1030303@oracle.com>
Date: Thu, 04 Jun 2009 08:42:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wimax: depend on rfkill properly
References: <1244096545.22576.9.camel@johannes.local>
In-Reply-To: <1244096545.22576.9.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> My mistake, I should have added that when cleaning up
> rfkill and changing wimax.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  net/wimax/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- wireless-testing.orig/net/wimax/Kconfig	2009-06-04 08:20:57.000000000 +0200
> +++ wireless-testing/net/wimax/Kconfig	2009-06-04 08:21:09.000000000 +0200
> @@ -4,6 +4,7 @@
>  
>  menuconfig WIMAX
>  	tristate "WiMAX Wireless Broadband support"
> +	depends on RFKILL || !RFKILL
>  	help
>  
>  	  Select to configure support for devices that provide
> 
> 


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
