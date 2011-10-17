Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1JQQjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 12:39:41 -0400
Subject: Re: [PATCH 1/2] nl80211: Add sta_flags to the station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111013_163117_644066_A3E4DBE3)
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111013_163117_644066_A3E4DBE3)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 18:39:37 +0200
Message-ID: <1318869577.3960.12.camel@jlt3.sipsolutions.net> (sfid-20111017_183944_428918_ED0784F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-13 at 16:30 +0200, Helmut Schaa wrote:
> Reuse the already existing struct nl80211_sta_flag_update to specify
> both, a flag mask and the flag set itself. This means
> nl80211_sta_flag_update is now used for setting station flags and also
> for getting station flags.

Got a corresponding iw patch?

johannes

