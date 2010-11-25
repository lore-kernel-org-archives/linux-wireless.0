Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0KYSFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 13:05:10 -0500
Subject: Re: [PATCH 1/2] nl80211/cfg80211: extend mgmt-tx API for
 off-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4CEE962C.8060203@candelatech.com>
References: <20101125090228.087298683@sipsolutions.net>
	 <20101125090254.456149961@sipsolutions.net>
	 <4CEE962C.8060203@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 19:05:00 +0100
Message-ID: <1290708300.3770.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-25 at 09:00 -0800, Ben Greear wrote:
> What are the units for DURATION?  It seems the code is treating
> that as jiffies, but surely user-space should specify in msecs
> or similar and have the kernel do the conversion?

This code isn't even using them at all, and the nl80211 API specifies
milliseconds. Where do you see it look like jiffies?

johannes

