Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2KENMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 08:12:47 -0500
Message-ID: <1352121202.9466.3.camel@jlt4.sipsolutions.net> (sfid-20121105_141302_245719_C14B2201)
Subject: Re: [PATCH] mac80211: send deauth only with channel context
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Mon, 05 Nov 2012 14:13:22 +0100
In-Reply-To: <1351586491-28634-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_094102_786162_CFCF33FC)
References: <1351586491-28634-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121030_094102_786162_CFCF33FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-30 at 09:41 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When userspace asks to deauthenticate and we're just
> authenticated (or still authenticating) send a deauth
> frame instead of deleting the auth request.
> 
> On the other hand, if we've just disassociated and
> therefore deleted all our state already, drop the
> deauth request because we no longer have a channel
> context to send it on.

Applied.

johannes

