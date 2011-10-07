Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1JGTyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 15:54:25 -0400
Subject: Re: [PATCH 3/8] cfg80211: process regulatory DFS region for
 countries
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1317772067-6998-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014806_861657_74E532F3)
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1317772067-6998-4-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111005_014806_861657_74E532F3)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 21:54:20 +0200
Message-ID: <1318017260.3974.9.camel@jlt3.sipsolutions.net> (sfid-20111007_215444_087210_F5FD032C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-04 at 16:47 -0700, Luis R. Rodriguez wrote:

>  /**
> + * enum nl80211_dfs_regions - regulatory DFS regions
> + *
> + * @NL80211_DFS_UNSET: Country has no DFS master region specified
> + * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
> + * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
> + * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
> + */
> +enum nl80211_cflags {
> +	NL80211_DFS_UNSET	= 0,

That seems odd -- nl80211 convention would be to just leave out the
attribute.

johannes

