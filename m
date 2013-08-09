Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab3HINPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:15:44 -0400
Message-ID: <1376054140.8355.7.camel@jlt4.sipsolutions.net> (sfid-20130809_151549_704064_5EB43496)
Subject: Re: [PATCH 1/7] cfg80211: export cfg80211_chandef_dfs_required
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 09 Aug 2013 15:15:40 +0200
In-Reply-To: <1375457886-7275-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1375457886-7275-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-02 at 17:38 +0200, Simon Wunderlich wrote:

>  
> -/**
> - * cfg80211_chandef_dfs_required - checks if radar detection is required
> - * @wiphy: the wiphy to validate against
> - * @chandef: the channel definition to check
> - * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
> - */
> -int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> -				  const struct cfg80211_chan_def *c);
>  

Please delete one of the blank lines too :)

johannes

