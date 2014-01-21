Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaAUQAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:00:17 -0500
Message-ID: <1390320014.6199.61.camel@jlt4.sipsolutions.net> (sfid-20140121_170020_632990_0D1B039E)
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information
 through get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 21 Jan 2014 17:00:14 +0100
In-Reply-To: <1390302591-3352-2-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
	 <1390302591-3352-2-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 12:09 +0100, Antonio Quartulli wrote:

> + * @prob: probability of success of this birate

typo: bitrate

> +struct cfg80211_minstrel_rate_info {
> +	u32 bitrate;
> +	u32 prob;
> +};

Do you actually care about this, rather than bitrate*prob, ie. something
like "expected throughput"? Actually this isn't expected throughput, but
wouldn't something like expected throughput make even more sense?

johannes

