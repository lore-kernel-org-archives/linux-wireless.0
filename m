Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaDVOxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:53:49 -0400
Message-ID: <1398178421.4211.12.camel@jlt4.sipsolutions.net> (sfid-20140422_165357_117043_5479382E)
Subject: Re: [PATCH 11/12] cfg80211/mac80211: rename
 cfg80211_chandef_dfs_required()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:53:41 +0200
In-Reply-To: <00719736535b7e8348c746cf44cc453dd7893e14.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065526_850039_ECC986BC)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <00719736535b7e8348c746cf44cc453dd7893e14.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065526_850039_ECC986BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Change the name to cfg80211_chandef_dfs_check to emphasize that the
> function isn't a bool function, its return value must be fully
> checked.
> 
> Also rename the helper function's name to
> cfg80211_do_chandef_dfs_check for consistency.
> 
> Variable width in cfg80211_chandef_dfs_check() needn't to be checked
> for sanity, since above cfg80211_chandef_valid() already checked the
> sanity of chandef->width.
> 
> Since cfg80211.h is touched, also correct a typo in comment.

I think there's too much work ongoing in this area to safely apply this.

johannes

