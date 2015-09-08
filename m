Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46621 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbbIHP7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:59:20 -0400
Message-ID: <1441727954.1906.16.camel@sipsolutions.net> (sfid-20150908_175923_591420_9AC8C58B)
Subject: Re: [PATCH 01/30] staging: wilc1000: rename WILC_WFI_CfgSetChannel
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaehyun Lim <chaehyun.lim@gmail.com>, gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 08 Sep 2015 17:59:14 +0200
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175617_481363_B42F74DF)
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
	 (sfid-20150908_175617_481363_B42F74DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -static int WILC_WFI_CfgSetChannel(struct wiphy *wiphy,
> +static int wilc_cfg80211_set_monitor_channel(struct wiphy *wiphy,
>  				  struct cfg80211_chan_def *chandef)
>  {
> 
You should probably consider not breaking indentation while doing this
:)

And perhaps cfg80211_ in there is a bit too long - I'm not sure it's
needed at all, but if so cfg_ would probably be sufficient?

johannes
