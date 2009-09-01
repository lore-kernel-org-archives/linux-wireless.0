Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55806 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZIAPxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:53:21 -0400
Received: by fxm17 with SMTP id 17so126172fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:53:22 -0700 (PDT)
Message-ID: <4A9D436E.20509@lwfinger.net>
Date: Tue, 01 Sep 2009 10:53:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] wireless: update WIRELESS_EXT kconfig entry
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com> <1251818566-9264-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-6-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Provide more documentation as to why its being deprecated.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/Kconfig |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 08f6733..521ef6a 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -98,8 +98,16 @@ config WIRELESS_EXT
>  	bool "Wireless extensions"
>  	default y
>  	---help---
> -	  This option enables the legacy wireless extensions
> -	  (wireless network interface configuration via ioctls.)
> +	  This option enables the legacy wireless extensions.
> +	  Wireless extensions was the first 802.11 wireless configuration
> +	  API used by the networking subsystem. You will not need this unless
> +	  you have old userspace utilities or old wireless devices which
> +	  have not yet been ported to cfg80211.

I would like this to read "You will need this if you have old
userspace utilities or old wireless devices that have not yet been
ported to cfg80211."

Larry

