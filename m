Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34266 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbbKWQqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 11:46:42 -0500
Received: by qgeb1 with SMTP id b1so117976523qge.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 08:46:41 -0800 (PST)
Date: Mon, 23 Nov 2015 11:46:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-testing repo
Message-ID: <20151123164640.GA4037@localhost> (sfid-20151123_174648_296373_A39D6028)
References: <5652F62A.4000109@broadcom.com>
 <1448278260.5792.1.camel@sipsolutions.net>
 <5652FAB5.8030708@broadcom.com>
 <20151123160159.GA3755@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151123160159.GA3755@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 11:02:00AM -0500, John W. Linville wrote:
> > We have some setups running on wl-testing kernel and some running distro
> > kernel using backports.
> 
> I believe the Bob Copeland is considering taking on this mantle...

"a" Bob Copeland :)

Yeah, I would be game for maintaining this for a while -- I've scripted
a bit of it and have a practice tree over here, although of course it
should be on kernel.org when for reals:

    https://github.com/bcopeland/wireless-testing-testing

But if maintenance becomes a burden there's no reason we couldn't spread
the load.

-- 
Bob Copeland %% http://bobcopeland.com/
