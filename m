Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYXRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 18:17:23 -0500
Message-ID: <1359155867.4655.55.camel@jlt4.sipsolutions.net> (sfid-20130126_001726_220336_BB9D2B2E)
Subject: Re: Warning with trace while trying to connect to an AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Wollrath <jwollrath@web.de>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 26 Jan 2013 00:17:47 +0100
In-Reply-To: <20121223143452.1d029621@ilfaris> (sfid-20121223_143502_563235_989FE958)
References: <20121223143452.1d029621@ilfaris>
	 (sfid-20121223_143502_563235_989FE958)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-12-23 at 14:34 +0100, Julian Wollrath wrote:
> Hello,
> 
> while trying to connect to an AP I got the following trace:
> [13677.506164] ------------[ cut here ]------------
> [13677.506196] WARNING: at net/wireless/mlme.c:517 cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()

Are you able to reproduce this by any chance? It's been happening for a
while, but I've so far been unable to figure out what causes
"wdev->sme_state" and "wdev->current_bss" to get out of sync ...

If you could reproduce, a trace would help.

johannes

