Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63712 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZHNHHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 03:07:43 -0400
Message-ID: <4A850D2F.6080308@nokia.com>
Date: Fri, 14 Aug 2009 10:07:27 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>
Subject: Re: [PATCH v2 24/25] wl12xx: be consistent with the other group driver
 entries
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com> <1250210584-13374-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-25-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Luis R. Rodriguez wrote:
> Other TI drivers can land here now.
>
> Cc: Kalle Valo <kalle.valo@nokia.com>
> Cc: Luciano Coelho <luciano.coelho@nokia.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/wl12xx/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 78029fd..f4510f7 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -1,5 +1,5 @@
>  config WL12XX
> -	boolean "TI wl12xx driver support"
> +	boolean "Texas Instruments"
>  	depends on MAC80211 && EXPERIMENTAL
>  	---help---
>  	  This will enable TI wl12xx driver support. The drivers make
>   

I think the description of this option should be changed as well.  What 
about s/This will enable TI wl12xx driver support/This will enable 
support for Texas Instruments chipsets/ ?

-- 
Cheers,
Luca.

