Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57074 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaJIJG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:06:28 -0400
Message-ID: <1412845586.1828.27.camel@jlt4.sipsolutions.net> (sfid-20141009_110632_522861_4A9CCF76)
Subject: Re: [PATCH] mac80211/trivial: fix typo in starting baserate for
 rts_cts_rate_idx
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 09 Oct 2014 11:06:26 +0200
In-Reply-To: <1412690018-18429-1-git-send-email-karl.beldan@gmail.com> (sfid-20141007_155400_521821_8DEC99D2)
References: <1412690018-18429-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141007_155400_521821_8DEC99D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 15:53 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>

Is that really trivial? It seems to have some impact on the code, but I
can't right now say exactly what the impact is. Can you describe it and
say whether I should add it to mac80211 or mac80211-next? For "trivial"
I'd probably say mac80211-next, but this might be more important than
that?

johannes

