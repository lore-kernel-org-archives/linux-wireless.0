Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1AaSxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:53:52 -0500
Subject: Re: [PATCH] mac80211: disable power save if an infra AP vif exists
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296499518-3895-1-git-send-email-rmanoharan@atheros.com>
References: <1296499518-3895-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 19:53:38 +0100
Message-ID: <1296500018.3812.42.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 00:15 +0530, Rajkumar Manoharan wrote:

> +		if ((sdata->vif.type == NL80211_IFTYPE_AP) ||
> +		    (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {

I still think you should drop the VLAN check?

johannes

