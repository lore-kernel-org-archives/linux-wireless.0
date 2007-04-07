Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:50617 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965641AbXDGIu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 04:50:26 -0400
Date: Sat, 7 Apr 2007 10:50:25 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 debugfs compile failure
Message-ID: <20070407085025.GA2069@p15091797.pureserver.info>
References: <200704070028.02143.mb@bu3sch.de> <4616CD15.80405@gentoo.org> <1ba2fa240704061554t489c5efahb60472c9385a324c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240704061554t489c5efahb60472c9385a324c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-04-07 01:54 Tomas Winkler wrote:

> John
> Can you give this patch some higher priority. It's not nice to have a
> compilation breakage for so long time in the 'main' branch.
> Thanks
> Tomas
> 
> > From Johannes:
> >[PATCH] fix debugfs compile w/o debug counters
> >

I've just fetched from John's wireless-dev tree. The patch is in
there as commit 32bfb29ad.

-- 
Uli Kunitz
