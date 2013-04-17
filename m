Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966840Ab3DQWJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 18:09:55 -0400
Message-ID: <1366236590.8217.64.camel@jlt4.sipsolutions.net> (sfid-20130418_001014_392681_2C908D68)
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paul Stewart <pstew@chromium.org>
Date: Thu, 18 Apr 2013 00:09:50 +0200
In-Reply-To: <1366236369-543-1-git-send-email-bzhao@marvell.com> (sfid-20130418_000709_842159_3005786A)
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
	 (sfid-20130418_000709_842159_3005786A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-17 at 15:06 -0700, Bing Zhao wrote:
> Add a "wireless/nl80211_iftype" entry in the net device sysfs
> file structure to indicate the mode of the wireless device so
> it can be discovered easily from userspace.

What's wrong with "iw dev", i.e. netlink/nl80211?

johannes

