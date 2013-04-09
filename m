Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937478Ab3DIKLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 06:11:49 -0400
Message-ID: <1365502302.8465.24.camel@jlt4.sipsolutions.net> (sfid-20130409_121154_072178_060149D7)
Subject: Re: [PATCH] mac80211: provide SSID for IBSS vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 09 Apr 2013 12:11:42 +0200
In-Reply-To: <1365173181-5142-1-git-send-email-marek.puzyniak@tieto.com>
References: <1365173181-5142-1-git-send-email-marek.puzyniak@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	sdata->vif.bss_conf.ssid_len = ifibss->ssid_len;
> +	memcpy(sdata->vif.bss_conf.ssid, ifibss->ssid, ifibss->ssid_len);

I think you should also clear the ssid_len when disconnecting.

johannes

