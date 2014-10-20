Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35601 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbaJTH2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 03:28:09 -0400
Message-ID: <1413790086.10246.1.camel@jlt4.sipsolutions.net> (sfid-20141020_092813_425937_BFEABC7D)
Subject: Re: [PATCH] mac80211: minstrels: fix buffer overflow in HT debugfs
 rc_stats
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Mon, 20 Oct 2014 09:28:06 +0200
In-Reply-To: <20141019102255.GA30711@magnum.frso.rivierawaves.com> (sfid-20141019_122307_210658_6460AF92)
References: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
	 <20141019102255.GA30711@magnum.frso.rivierawaves.com>
	 (sfid-20141019_122307_210658_6460AF92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-10-19 at 12:22 +0200, Karl Beldan wrote:

> This would require rebasing "[PATCH v3 4/4] mac80211: minstrel_ht: add
> basic support for VHT rates <= 3SS@80MHz", and send 
> 
> [PATCH v2] mac80211: minstrels: fix buffer overflow in HT debugfs
> [PATCH v4 1/4] mac80211: minstrel_ht: Increase the range of handled
> [PATCH v4 2/4] mac80211: minstrel_ht: macros adjustments for future
> [PATCH v4 3/4] mac80211: minstrel_ht: include type (cck/ht) in rates
> [PATCH v4 4/4] mac80211: minstrel_ht: add basic support for VHT rates
> 
> Is it ok ?

Who are you asking? Those are your own patches, no? So are you asking
yourself if you can rebase? ;-)

For me that's fine.

johannes

