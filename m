Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab0JDTBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:01:22 -0400
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA2247.50402@candelatech.com>
References: <4CAA2247.50402@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:01:19 +0200
Message-ID: <1286218879.3620.55.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
> Just in case this seems familiar to anyone...
> 
> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]

Do you have debug info that'd point to a code line?

I have never heard of this.

johannes

