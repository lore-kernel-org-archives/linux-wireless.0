Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab3BFQ0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 11:26:47 -0500
Message-ID: <1360168022.7910.22.camel@jlt4.sipsolutions.net> (sfid-20130206_172716_274995_BD0F7C1B)
Subject: Re: [PATCH] net: mac80211/cfg.c: fix error using of sizeof()
From: Johannes Berg <johannes@sipsolutions.net>
To: Cong Ding <dinggnu@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 17:27:02 +0100
In-Reply-To: <1360167826-29265-1-git-send-email-dinggnu@gmail.com> (sfid-20130206_172354_765098_665D60D0)
References: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
	 (sfid-20130206_172354_765098_665D60D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 17:23 +0100, Cong Ding wrote:
> Using 'sizeof' on array given as function argument returns size of a pointer
> rather than the size of array.

Oops, yeah, Stephen Hemminger pointed this out a month or so ago and I
forgot to change it, thanks.

johannes

