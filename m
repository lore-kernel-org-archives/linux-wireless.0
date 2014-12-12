Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32930 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbaLLLkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:40:53 -0500
Message-ID: <1418384444.2470.22.camel@sipsolutions.net> (sfid-20141212_124056_697035_1D659956)
Subject: Re: [PATCH 3/4] ath10k: Fix no-ack frame status
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 12 Dec 2014 12:40:44 +0100
In-Reply-To: <87oarazecg.fsf@kamboji.qca.qualcomm.com>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
	 <1418226973-13779-3-git-send-email-sujith@msujith.org>
	 <87oarazecg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-11 at 12:10 +0200, Kalle Valo wrote:
> Sujith Manoharan <sujith@msujith.org> writes:
> 
> > From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> >
> > Use the new IEEE80211_TX_STAT_NOACK_TRANSMITTED flag
> > to indicate successful transmission of no-ack frames.
> > This fixes multicast frame accounting.
> >
> > Cc: ath10k@lists.infradead.org
> > Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Johannes, are you planning to take this? Or should I take this once the
> corresponding mac80211 patch trickles down to my tree?

I don't really want to take the driver patches, but I'll try to get to
the mac80211 ones today.

johannes

