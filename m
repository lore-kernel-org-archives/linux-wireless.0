Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1HaGgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:36:20 -0400
Subject: Re: [PATCH v2 1/4] nl80211: Parse channel type attribute in an
 IBSS join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2053881.ENil2Dy3QM@alex-1> (sfid-20110829_161556_944174_8A64BBCC)
References: <2053881.ENil2Dy3QM@alex-1>
	 (sfid-20110829_161556_944174_8A64BBCC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:36:17 +0200
Message-ID: <1314772577.4161.12.camel@jlt3.sipsolutions.net> (sfid-20110831_083623_187858_F780CF99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 16:15 +0200, Alexander Simon wrote:

> +/**
> + * cfg80211_can_use_ext_chan - test if ht40 on extension channel can be used
> + * @wiphy: the wiphy
> + * @chan: main channel
> + * @channel_type: HT mode
> + */
> +bool cfg80211_can_use_ext_chan(struct wiphy *wiphy,
> +			       struct ieee80211_channel *chan,
> +			       enum nl80211_channel_type channel_type);

Use for what? That's confusing. You're asking if it can be used for
beaconing, as the old function name *clearly* said. Now you're making it
confusing.

johannes

