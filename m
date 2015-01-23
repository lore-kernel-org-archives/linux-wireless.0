Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35475 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAWJyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:54:18 -0500
Message-ID: <1422006855.2728.18.camel@sipsolutions.net> (sfid-20150123_105424_007123_A71505C1)
Subject: Re: [PATCH] mac80211: properly set CCK flag in radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathy Vanhoef <vanhoefm@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:54:15 +0100
In-Reply-To: <54BE6094.6010001@gmail.com> (sfid-20150120_150512_222205_85BF3FC3)
References: <54BE6094.6010001@gmail.com>
	 (sfid-20150120_150512_222205_85BF3FC3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 15:05 +0100, Mathy Vanhoef wrote:
> Fix a regression introduced by commit a5e70697d0c4 ("mac80211: add radiotap flag
> and handling for 5/10 MHz") where the IEEE80211_CHAN_CCK channel type flag was
> incorrectly replaced by the IEEE80211_CHAN_OFDM flag. This commit fixes that by
> using the CCK flag again.

Applied.

johannes

