Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41388 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYJ0X0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 19:26:13 -0400
Date: Mon, 27 Oct 2008 19:25:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH/RFC] mac80211: convert to %pM away from print_mac
Message-ID: <20081027232518.GK20389@tuxdriver.com> (sfid-20081028_002618_461175_2D83E3CB)
References: <1224892243.3919.32.camel@johannes.berg> <20081027.155243.206513005.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081027.155243.206513005.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 03:52:43PM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sat, 25 Oct 2008 01:50:43 +0200
> 
> > Also remove a few stray DECLARE_MAC_BUF that were no longer
> > used at all.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Not sure this will apply to your tree, I prepared it against John's tree
> > which might have more things. If you put the previous patch in, I
> > suppose John _could_ put it into his tree, but then he'd have to pull in
> > yours which he normally doesn't... No idea. I can also just postpone
> > this?
> 
> I munged this to apply to my tree, the only conflicts were in
> mlme.c
> 
> Sorry John, one of us had to deal with this :-)

No, this seems fine to me.  I'll try to stay aware of it for possible
merge conflicts...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
