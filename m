Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2KMUoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:44:02 -0500
Message-ID: <1352839474.9466.33.camel@jlt4.sipsolutions.net> (sfid-20121113_214406_991297_81A37AED)
Subject: Re: [PATCH v2] mac80211: support RX_FLAG_MACTIME_END
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 21:44:34 +0100
In-Reply-To: <1352832387-21162-1-git-send-email-thomas@cozybit.com> (sfid-20121113_194649_145401_03E0E506)
References: <1352832387-21162-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121113_194649_145401_03E0E506)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 10:46 -0800, Thomas Pedersen wrote:
> Allow drivers to indicate their mactime is at RX completion and adjust
> for this in mac80211. Also rename the existing RX_FLAG_MACTIME_MPDU to
> RX_FLAG_MACTIME_START to clarify its intent. Based on similar code by
> Johannes Berg.

Applied, but I had to fix up the patch to apply on mac80211-next, and
even had to make it compile by adjusting the Atheros drivers ...

johannes

