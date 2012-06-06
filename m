Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2FFKXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:23:33 -0400
Message-ID: <1338978209.4513.54.camel@jlt3.sipsolutions.net> (sfid-20120606_122346_513092_BF303950)
Subject: Re: [PATCH 1/4] {nl,cfg,mac}80211: implement
 dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Wed, 06 Jun 2012 12:23:29 +0200
In-Reply-To: <1338978039-4269-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122105_122053_70B8E392)
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
	 <1338978039-4269-2-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120606_122105_122053_70B8E392)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 18:20 +0800, Chun-Yeow Yeoh wrote:

> @@ -2175,11 +2182,13 @@ enum nl80211_meshconf_params {
>  	NL80211_MESHCONF_PATH_REFRESH_TIME,
>  	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
>  	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
> +	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
>  	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
>  	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
>  	NL80211_MESHCONF_HWMP_ROOTMODE,
>  	NL80211_MESHCONF_ELEMENT_TTL,
>  	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
> +	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,

Heh, no, you can't do this.

johannes

