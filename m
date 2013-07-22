Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3GVNds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 09:33:48 -0400
Message-ID: <1374500018.14517.10.camel@jlt4.sipsolutions.net> (sfid-20130722_153351_314238_3A202564)
Subject: Re: [PATCH v2] mac80211: prevent the buffering or frame
 transmission to non-assoc mesh STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 22 Jul 2013 15:33:38 +0200
In-Reply-To: <1374226659-2929-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130719_114620_739880_0A8DC3A3)
References: <1374226659-2929-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130719_114620_739880_0A8DC3A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-19 at 17:37 +0800, Chun-Yeow Yeoh wrote:
> This patch is intended to avoid the buffering to non-assoc mesh STA
> and also to avoid the triggering of frame to non-assoc mesh STA which
> could cause kernel panic in specific hw.

Applied. I still find checking the station state a bit odd, but I guess
making sure the station is fine in the callers isn't possible?

johannes

