Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2FDKVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:21:34 -0400
Message-ID: <1338805292.4512.8.camel@jlt3.sipsolutions.net> (sfid-20120604_122137_550103_DE98F045)
Subject: Re: [RFC] cfg80211: 11ac change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 04 Jun 2012 12:21:32 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A4550@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A4550@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-04 at 09:43 +0000, Mahesh Palivela wrote:
> Hi,
> 
> As part of 11ac changes I had modified cfg80211 to push hw VHT capabilities to NL layer. Please review.
> 
> Signed off by: Mahesh Palivela


Please re-read the available documentation on patch formatting,
changelogs, signed-off-by, etc. You're getting almost everything wrong
that you can :-)

> +/* 802.11ac VHT Capabilities */
> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
...
> +#define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN                  0x20000000

> +    u16 cap; /* use IEEE80211_VHT_CAP_ */

so how exactly is that going to fit?

johannes

