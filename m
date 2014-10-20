Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37862 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJTOi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 10:38:56 -0400
Message-ID: <1413815932.24269.1.camel@jlt4.sipsolutions.net> (sfid-20141020_163911_096831_39B64705)
Subject: Re: [PATCH v2] mac80211: minstrels: fix buffer overflow in HT
 debugfs rc_stats
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 16:38:52 +0200
In-Reply-To: <1413795276-11949-1-git-send-email-karl.beldan@gmail.com> (sfid-20141020_105450_329743_C536AD8D)
References: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
	 <1413795276-11949-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141020_105450_329743_C536AD8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 10:54 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM an HT rc_stats line is 106 chars.
> Times 8(MCS_GROUP_RATES)*3(SS)*2(GI)*2(BW) + CCK(4), i.e. x100, this is
> well above the current 8192 - sizeof(*ms) currently allocated.

Applied.

johannes

