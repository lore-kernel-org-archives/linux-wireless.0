Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1FUHFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 03:05:11 -0400
Subject: Re: [PATCH] netlink: advertise incomplete dumps
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	samuel@sortiz.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, tgraf@suug.ch
In-Reply-To: <20110620.135929.942453687487758741.davem@davemloft.net>
References: <1308570046.4322.5.camel@jlt3.sipsolutions.net>
	 <20110620.135929.942453687487758741.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 09:05:05 +0200
Message-ID: <1308639905.3900.0.camel@jlt3.sipsolutions.net> (sfid-20110621_090520_201070_0F3D1287)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 13:59 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Mon, 20 Jun 2011 13:40:46 +0200
> 
> > Should we merge this through wireless? From wireless-next it'll go into
> > net-next quickly, but the converse isn't true, so using it in wireless
> > would be harder if it was merged through net-next I think? Or John can
> > cherry-pick into wireless-testing?
> 
> I'm fine with this going in via the wireless tree, that way we'll
> see a real user when it merged into net-next-2.6

Thomas said he also has updated some of the core netlink code, but I'll
also have a real user ready and the NFC subsystem is also using it and
those are coming in through wireless. Thanks!

johannes

