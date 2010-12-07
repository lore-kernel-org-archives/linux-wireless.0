Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LGUE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:04:26 -0500
Subject: Re: [PATCH] mac80211: Fix BUG in pskb_expand_head when
 transmitting shared skbs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101207194920.GH2700@tuxdriver.com>
References: <1291311849-13086-1-git-send-email-helmut.schaa@googlemail.com>
	 <20101207194920.GH2700@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 21:04:17 +0100
Message-ID: <1291752257.3607.58.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 14:49 -0500, John W. Linville wrote:

> > It would be possible to avoid another resize of the copied skb by using
> > skb_copy_expand instead of skb_copy but that would make the patch more
> > complex. Also, shared skbs are a corner case right now, so the resize
> > shouldn't matter much.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> Is this intended for 2.6.37?  It looks like it would apply there.

Yeah, and probably older stable too.

johannes

