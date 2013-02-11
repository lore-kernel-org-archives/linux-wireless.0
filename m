Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513Ab3BKUjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 15:39:47 -0500
Message-ID: <1360615181.8738.37.camel@jlt4.sipsolutions.net> (sfid-20130211_213951_274921_23F273A2)
Subject: Re: pull-request: mac80211 2013-02-11
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 21:39:41 +0100
In-Reply-To: <20130211192728.GD10986@tuxdriver.com>
References: <1360168561.7910.24.camel@jlt4.sipsolutions.net>
	 <1360267300.8038.13.camel@jlt4.sipsolutions.net>
	 <1360580674.8738.14.camel@jlt4.sipsolutions.net>
	 <20130211192728.GD10986@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 14:27 -0500, John W. Linville wrote:

> > Here are three fixes still for the 3.8 stream, the fix from Cong Ding
> > for the bad sizeof (Stephen Hemminger had pointed it out before but I'd
> > promptly forgotten), a mac80211 managed-mode channel context usage fix
> > where a downgrade would never stop until reaching non-HT and a bug in
> > the channel determination that could cause invalid channels like HT40+
> > on channel 11 to be used.

> Pulling now -- no guarantees that it will make the loop before 3.8
> is released!

Yeah, I understand. I'll post them to stable afterwards if not.

johannes

