Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbXGCFiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 01:38:21 -0400
Date: Mon, 02 Jul 2007 22:38:40 -0700 (PDT)
Message-Id: <20070702.223840.99827968.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Set low initial rate in rc80211_simple
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070612012411.GI20422@tuxdriver.com>
References: <20070612012228.GG20422@tuxdriver.com>
	<20070612012319.GH20422@tuxdriver.com>
	<20070612012411.GI20422@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 11 Jun 2007 21:24:11 -0400

> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. For situations for which the signal is weak,
> the rate may be too high for authentication and association. Although
> the rc80211_simple module will adjust the speed, the response may not
> be fast enough for a successful connection. This modification sets the
> initial rate to the lowest supported value.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Applied to net-2.6.23
