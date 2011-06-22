Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:50:09 -0400
Subject: Re: Performance regression between Madwifi/net80211 and
 ath5k/mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
References: <loom.20110621T215346-191@post.gmane.org>
	 <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
	 <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
	 (sfid-20110622_154146_913504_76736765) <1308750416.29571.10.camel@jlt3.sipsolutions.net>
	 <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 16:50:04 +0200
Message-ID: <1308754204.29571.15.camel@jlt3.sipsolutions.net> (sfid-20110622_165013_676735_B307F0DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 07:41 -0700, Joerg Pommnitz wrote:

> To answer your actual question: No, there doesn't seem to be a
> difference in CPU usage as shown by top. If anything, madwifi 
> seems to use a little bit more:
> 
> madwifi: 85,5% idle, 10% si
> ath5k  : 89% idle,   10% si

That seems insignificant with so much idle.

> The CPU is:
> 
> processor    : 0
> vendor_id    : GenuineIntel
> cpu family    : 6
> model        : 13
> model name    : Intel(R) Celeron(R) M processor         1.00GHz

So it should be a fairly capable system.

I guess you'll need more help from the HW people here.

johannes

