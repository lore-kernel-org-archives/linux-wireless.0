Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:60045 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZG1PY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 11:24:59 -0400
Received: by ey-out-2122.google.com with SMTP id 9so31155eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 08:24:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v2] rt2x00: move experimental on kconfig only to rt2800usb
Date: Tue, 28 Jul 2009 17:24:55 +0200
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <1248793422-9106-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248793422-9106-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907281724.56015.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 July 2009, Luis R. Rodriguez wrote:
> These drivers have been around for a while, if there are issues
> they should be reported. rt2800usb is still a bit flaky though.
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Thanks.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/Kconfig |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index f970aa2..ed1f997 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -1,8 +1,8 @@
>  menuconfig RT2X00
>  	tristate "Ralink driver support"
> -	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> +	depends on MAC80211 && WLAN_80211
>  	---help---
> -	  This will enable the experimental support for the Ralink drivers,
> +	  This will enable the support for the Ralink drivers,
>  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
>  
>  	  These drivers make use of the mac80211 stack.
> @@ -79,14 +79,14 @@ config RT73USB
>  
>  config RT2800USB
>  	tristate "Ralink rt2800 (USB) support"
> -	depends on USB
> +	depends on USB && EXPERIMENTAL
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_HT
>  	select RT2X00_LIB_FIRMWARE
>  	select RT2X00_LIB_CRYPTO
>  	select CRC_CCITT
>  	---help---
> -	  This adds support for rt2800 wireless chipset family.
> +	  This adds experimental support for rt2800 wireless chipset family.
>  	  Supported chips: RT2770, RT2870 & RT3070.
>  
>  	  When compiled as a module, this driver will be called "rt2800usb.ko".


