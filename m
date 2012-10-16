Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab2JPSTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:19:04 -0400
Message-ID: <1350411578.10177.6.camel@jlt4.sipsolutions.net> (sfid-20121016_201909_806201_FE4FD4BB)
Subject: Re: [RFC] mac80211: connect with HT20 if HT40 is not permitted
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Paul Stewart <pstew@chromium.org>
Date: Tue, 16 Oct 2012 20:19:38 +0200
In-Reply-To: <1349100121.10330.36.camel@jlt4.sipsolutions.net> (sfid-20121001_160132_854322_0F7EDEE5)
References: <1349100121.10330.36.camel@jlt4.sipsolutions.net>
	 (sfid-20121001_160132_854322_0F7EDEE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-01 at 16:02 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some changes to fix issues with HT40 APs in Korea
> and follow-up changes to allow using HT40 even if
> the local regulatory database disallows it caused
> issues with iwlwifi (and could cause issues with
> other devices); iwlwifi firmware would assert if
> you tried to connect to an AP that has an invalid
> configuration (e.g. using HT40- on channel 140.)
> 
> Fix this, while avoiding the "Korean AP" issue by
> disabling HT40 and advertising HT20 to the AP
> when connecting.

No comments, so I'm applying this :)

johannes

