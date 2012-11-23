Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2KWWsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 17:48:18 -0500
Message-ID: <1353710926.5908.3.camel@jlt4.sipsolutions.net> (sfid-20121123_234824_830894_FE1F7535)
Subject: Re: [PATCH] iwlwifi: initialize rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 23 Nov 2012 23:48:46 +0100
In-Reply-To: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_234642_526071_AA7F642B)
References: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121123_234642_526071_AA7F642B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 23:46 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The vendor radiotap patch added a few fields to
> struct ieee80211_rx_status that need to be zero,
> initialize the struct instead of using whatever
> was left on the stack.

John, this fixes the crash you ran into, sorry about that. I also sent
the same iwlegacy fix separately yesterday.

Can you please apply the patch directly to wireless-next? I didn't think
sending a pull request for a single patch was really helpful, but if you
do want one I can do that too.

johannes

