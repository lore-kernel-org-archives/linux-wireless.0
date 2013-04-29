Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2507 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab3D2IGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 04:06:45 -0400
Message-ID: <517E2A04.5050209@broadcom.com> (sfid-20130429_100650_914634_4EA0DF14)
Date: Mon, 29 Apr 2013 10:06:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Marcel Holtmann" <marcel@holtmann.org>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Add generic netlink module alias for
 cfg80211/nl80211
References: <1367191326-30078-1-git-send-email-marcel@holtmann.org>
In-Reply-To: <1367191326-30078-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2013 01:22 AM, Marcel Holtmann wrote:
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 84c9ad7..68f0c96 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -34,6 +34,7 @@
>   MODULE_AUTHOR("Johannes Berg");
>   MODULE_LICENSE("GPL");
>   MODULE_DESCRIPTION("wireless configuration support");
> +MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);

Just being curious here (might learn something). What does this macro 
provide? Is it intended to help user-space tools identify the netlink 
API/family it provides?

>   /* RCU-protected (and cfg80211_mutex for writers) */
>   LIST_HEAD(cfg80211_rdev_list);

Regards,
Arend

