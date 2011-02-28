Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1B1OJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 09:09:36 -0500
Subject: Re: [PATCH v2 3/3] linux-firmware: wl12xx-Update AP Firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1298900612-22104-3-git-send-email-shahar_levi@ti.com>
References: <1298900612-22104-1-git-send-email-shahar_levi@ti.com>
	 <1298900612-22104-3-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 14:09:33 +0000
Message-ID: <1298902173.29377.40.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 15:43 +0200, Shahar Levi wrote:
> Update AP firmware to version 6.2.0.0.36
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
> Changes from v1:
>  - Gather to series (No change in patch)

Applying: linux-firmware: wl12xx-Update AP Firmware
error: patch failed: WHENCE:1467
error: WHENCE: patch does not apply
Patch failed at 0001 linux-firmware: wl12xx-Update AP Firmware
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".


> 
> WHENCE                           |    2 +-
>  ti-connectivity/wl1271-fw-ap.bin |  Bin 260992 -> 262356 bytes
>  2 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/WHENCE b/WHENCE
> index 1f25c84..0b882ae 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1467,7 +1467,7 @@ Licence: See LICENCE.ti-connectivity for details.
>  
>  	Station:      wl1271-fw.bin version 6.1.0.50.350 (RM version 206)
>  	Station:      wl1271-fw-2.bin version 6.1.3.50.55
> -	Access Point: wl1271-fw-ap.bin version 6.2.0.0.30 (RM version 6.2.0.0.6)
> +	Access Point: Access Point: wl1271-fw-ap.bin version 6.2.0.0.36
>  	
>  	The nvs file includes two parts:

That part ('Access Point: Access Point:') probably wasn't what you
intended anyway? Can you send another version against what I just pushed
out?


-- 
dwmw2

