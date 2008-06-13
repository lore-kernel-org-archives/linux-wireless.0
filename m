Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62827 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978AbYFMOto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:49:44 -0400
Message-ID: <4852891D.10600@lwfinger.net> (sfid-20080613_164948_378428_76EC51CB)
Date: Fri, 13 Jun 2008 09:50:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix for incorrect Subsystem and PCI Product IDs
 on rev 4 SPROMs
References: <200806131047.33710.mb@bu3sch.de>
In-Reply-To: <200806131047.33710.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> From: Larry.Finger@lwfinger.net
> 
> In current ssb-sprom code, the Subsystem and Product ID's are wrong for rev 4
> SPROM's.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> ---
> 
> John, this is a bugfix for 2.6.26.
> 
> 
> Index: ssb_sprom/ssb_sprom.h
> ===================================================================
> --- ssb_sprom.orig/ssb_sprom.h
> +++ ssb_sprom/ssb_sprom.h
> @@ -33,10 +33,10 @@
>  
>  /* byte offsets */
>  #define SPROM_SUBP		(0x02 * 2)
> -#define SPROM4_SUBP		(0x00 * 2)
> +#define SPROM4_SUBP		(0x02 * 2)
>  #define SPROM_SUBV		(0x03 * 2)
>  #define SPROM_PPID		(0x04 * 2)
> -#define SPROM4_PPID		(0x02 * 2)
> +#define SPROM4_PPID		(0x04 * 2)
>  #define SPROM_BFLHI		(0x1C * 2)
>  #define SPROM_IL0MACADDR	(0x24 * 2)
>  #define SPROM_ET0MACADDR	(0x27 * 2)
> 

The patch is for ssb-sprom, not ssb. If I still have any of my feeble 
mind left, ssb-sprom has not become part of the kernel. John, you can 
ignore this patch.

Larry



