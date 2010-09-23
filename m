Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0IWIap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 04:30:45 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C9A5CEB.9010708@candelatech.com>
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
	 <4C98DC5D.2000108@candelatech.com>
	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>
	 <4C98E05B.8050609@candelatech.com>
	 <1285088605.12764.5.camel@jlt3.sipsolutions.net>
	 <1285091341.12764.7.camel@jlt3.sipsolutions.net>
	 <4C9A35FD.8060201@candelatech.com>
	 <1285174896.3684.71.camel@jlt3.sipsolutions.net>
	 <4C9A3E1C.8070306@candelatech.com>
	 <1285180265.3684.74.camel@jlt3.sipsolutions.net>
	 <20100922184846.GI5515@tuxdriver.com>  <4C9A5CEB.9010708@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:30:39 +0200
Message-ID: <1285230639.3691.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 12:45 -0700, Ben Greear wrote:

> This look better?
> 
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index e81ef4e..ebd5b69 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -368,7 +368,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
>          if (!phyd)
>                  return;
> 
> -       local->debugfs.stations = debugfs_create_dir("stations", phyd);
>          local->debugfs.keys = debugfs_create_dir("keys", phyd);
> 
>          DEBUGFS_ADD(frequency);

Yeah, but completely whitespace damaged, you're going to have to work on
your submissions :)

Also, why do you do "[mac80211] mac80211" rather than "[PATCH]
mac80211"?

johannes

