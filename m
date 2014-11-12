Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34028 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751715AbaKLLrS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 06:47:18 -0500
Message-ID: <1415792829.3117.5.camel@coelho.fi> (sfid-20141112_124722_682283_2206FE4A)
From: Luca Coelho <luca@coelho.fi>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Nov 2014 13:47:09 +0200
In-Reply-To: <1415792197-23080-2-git-send-email-jukka.rissanen@linux.intel.com>
References: <1415792197-23080-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415792197-23080-2-git-send-email-jukka.rissanen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/2] nl80211: Replace interface socket owner
 attribute with more generic one
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 13:36 +0200, Jukka Rissanen wrote:
> @@ -2056,6 +2056,8 @@ enum nl80211_attrs {
>  #define NL80211_ATTR_KEY NL80211_ATTR_KEY
>  #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
>  #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
> +#define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
> +#define NL80211_ATTR_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER

The second define seems to be a mistake?

--
Luca.

