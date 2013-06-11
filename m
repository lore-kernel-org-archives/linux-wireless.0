Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FKTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:53:55 -0400
Message-ID: <1370980419.8356.68.camel@jlt4.sipsolutions.net> (sfid-20130611_215358_476304_9E2F846A)
Subject: Re: [PATCH] carl9170: make use of the new rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linville@tuxdriver.com,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org, nbd@nbd.name
Date: Tue, 11 Jun 2013 21:53:39 +0200
In-Reply-To: <201306112149.09768.chunkeey@googlemail.com> (sfid-20130611_214914_098355_4B143C81)
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de>
	 <1370978668.8356.67.camel@jlt4.sipsolutions.net>
	 <201306112149.09768.chunkeey@googlemail.com>
	 (sfid-20130611_214914_098355_4B143C81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 21:49 +0200, Christian Lamparter wrote:

> > > As I just saw an ath9k patch for rcu protection when ieee80211_get_tx_rates() is called.
> > > Should this be done in carl9170 as well ?
> > 
> > I think that patch is wrong actually, probably should just do the rcu
> > protection inside the function. However the patch is completely wrong
> > anyway (C isn't python) so ...
> Uh, that's confusing. We are now talking about the patch from Thomas, right?
> If so: the previous "new rate control api" feature patch for carl9170 should
> be fine in this regard.

No, Calvin Owens's patch.

johannes


