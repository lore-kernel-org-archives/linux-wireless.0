Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2G0JXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 05:23:33 -0400
Message-ID: <1343381009.4449.1.camel@jlt3.sipsolutions.net> (sfid-20120727_112336_508359_0679EC5D)
Subject: Re: [PATCH v2] mac80211: add PS flag to bss_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Jul 2012 11:23:29 +0200
In-Reply-To: <1343380724-4104-1-git-send-email-eliad@wizery.com> (sfid-20120727_111846_681009_6D59F38C)
References: <1343380724-4104-1-git-send-email-eliad@wizery.com>
	 (sfid-20120727_111846_681009_6D59F38C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good, but please undo this change:

> +bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata);

> -static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
> +bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)

since I don't see that you need it now.

johannes

