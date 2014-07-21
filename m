Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46850 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaGUORp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 10:17:45 -0400
Message-ID: <1405952257.32255.24.camel@jlt4.sipsolutions.net> (sfid-20140721_161750_173374_F86A15B5)
Subject: Re: [PATCH] mac80211: fix Rx reordering with RX_FLAG_AMSDU_MORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Jul 2014 16:17:37 +0200
In-Reply-To: <1405505371-13064-1-git-send-email-michal.kazior@tieto.com> (sfid-20140716_121849_042221_2932B9ED)
References: <1405505371-13064-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140716_121849_042221_2932B9ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-16 at 12:09 +0200, Michal Kazior wrote:
> Some drivers (e.g. ath10k) report A-MSDU subframes
> individually with identical seqno. The A-MPDU Rx
> reorder code did not account for that which made
> it practically unusable with drivers using
> RX_FLAG_AMSDU_MORE because it would end up
> dropping a lot of frames resulting in confusion in
> upper network transport layers.

Applied.

johannes

