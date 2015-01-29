Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48217 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbA2QCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 11:02:42 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] nl80211: don't document per-wiphy interface dump
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1422546796-22526-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 29 Jan 2015 08:02:36 -0800
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Message-Id: <6CBE8643-DD96-45AB-9F73-4CADC7FD2277@holtmann.org> (sfid-20150129_170246_892258_7AAAE738)
References: <1422546796-22526-1-git-send-email-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Such a feature doesn't exist and isn't really needed since you
> probably won't have enough interfaces to make it worthwhile, so
> just remove that from the documentation.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> include/uapi/linux/nl80211.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 1cbc3aae425c..68b294e83944 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -180,8 +180,8 @@
>  *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME.
>  *
>  * @NL80211_CMD_GET_INTERFACE: Request an interface's configuration;
> - *	either a dump request on a %NL80211_ATTR_WIPHY or a specific get
> - *	on an %NL80211_ATTR_IFINDEX is supported.
> + *	either a dump request for all interfaces or a specific get with a
> + *	single %NL80211_ATTR_IFINDEX is supported.
>  * @NL80211_CMD_SET_INTERFACE: Set type of a virtual interface, requires
>  *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE.
>  * @NL80211_CMD_NEW_INTERFACE: Newly created virtual interface or response

we had a TODO item internally that planned to implement this actually.

Regards

Marcel

