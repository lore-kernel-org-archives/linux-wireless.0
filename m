Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbaDVOyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:54:44 -0400
Message-ID: <1398178465.4211.13.camel@jlt4.sipsolutions.net> (sfid-20140422_165453_380677_4746501D)
Subject: Re: [PATCH 12/12] cfg80211/mac80211: change variable name
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:54:25 +0200
In-Reply-To: <556860ba8846b238bddd8f41af02842177e08ba9.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065529_898529_28593A0F)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <556860ba8846b238bddd8f41af02842177e08ba9.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065529_898529_28593A0F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Change "err" to "ret", since return value isn't zero doesn't always
> mean error occured, sometimes it means success.
> 
> if (err)
>         /* do things if function successfully returned */
> 
> looks strange to me, so change it.
> 
> This change related to the functions which call
> cfg80211_chandef_dfs_check(), since cfg80211_chandef_dfs_check()
> returns 1 means dfs is required.

Same here, there's a lot of work ongoing with CSA around the code, I
don't want to disrupt all that.

johannes

