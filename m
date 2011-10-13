Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1JMOnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:43:04 -0400
Subject: Re: [PATCH 1/2] nl80211: Add sta_flags to the station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111013_163117_644066_A3E4DBE3)
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111013_163117_644066_A3E4DBE3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 16:43:01 +0200
Message-ID: <1318516981.5612.20.camel@jlt3.sipsolutions.net> (sfid-20111013_164310_506172_38859BF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-13 at 16:30 +0200, Helmut Schaa wrote:
> Reuse the already existing struct nl80211_sta_flag_update to specify
> both, a flag mask and the flag set itself. This means
> nl80211_sta_flag_update is now used for setting station flags and also
> for getting station flags.

Why would we care about the mask here? Wouldn't a u32 attribute with the
set flags only make more sense?

johannes

