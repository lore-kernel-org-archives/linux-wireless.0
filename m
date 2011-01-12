Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab1ALN1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:27:31 -0500
Date: Wed, 12 Jan 2011 14:26:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Fix mixed usage of spin_lock and
 spin_lock_irqsave on same lock
Message-ID: <20110112132603.GA4111@redhat.com>
References: <4d2d3810.F6Slpvbu6tV67Lp2%Larry.Finger@lwfinger.net>
 <1294822933.3639.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294822933.3639.14.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 10:02:13AM +0100, Johannes Berg wrote:
> local->skb_queue[_unreliable]. I think Stanislaw was right on (but why
> didn't he offer a fix? :-) ).
Heh, I did't know such simple fix exist :)

Stanislaw
