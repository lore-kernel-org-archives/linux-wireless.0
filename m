Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2GBNHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 09:07:12 -0400
Message-ID: <1341234430.19642.9.camel@jlt3.sipsolutions.net> (sfid-20120702_150717_140847_49AE50F6)
Subject: Re: [PATCH] mac80211: reduce IEEE80211_TX_MAX_RATES from 5 to 4 to
 enable upcoming TPC support
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Date: Mon, 02 Jul 2012 15:07:10 +0200
In-Reply-To: <1340981843-81779-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_165846_247689_05DD2B23)
References: <1340981843-81779-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120629_165846_247689_05DD2B23)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 10:57 -0400, Thomas Huehn wrote:
> IEEE80211_TX_MAX_RATES are reduced from 5 to 4, as there is no hardware out
> there supporting a rate chain with 5 stages, so 4 is enough. The space that
> is freed will be used for the upcoming Transmission Power Control (TPC).

Applied, but I rewrote your commit message a bit, a clearer message
would be appreciated. :-)

johannes

