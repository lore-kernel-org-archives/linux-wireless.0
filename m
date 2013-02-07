Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3BGP0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 10:26:47 -0500
Message-ID: <1360250827.8038.10.camel@jlt4.sipsolutions.net> (sfid-20130207_162652_208598_C23FF57A)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	chaitanyatk@posedge.com, linux-wireless@vger.kernel.org,
	maheshp@posedge.com
Date: Thu, 07 Feb 2013 16:27:07 +0100
In-Reply-To: <5113C5E0.5050509@openwrt.org>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com>
	 <1360225230.8038.1.camel@jlt4.sipsolutions.net>
	 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com>
	 <1360228991.8038.3.camel@jlt4.sipsolutions.net>
	 <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
	 <5113B42A.4020708@openwrt.org>
	 <1360246653.8038.9.camel@jlt4.sipsolutions.net>
	 <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com>
	 <5113C5E0.5050509@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 16:18 +0100, Felix Fietkau wrote:

> > But whats the use of sending an AMSDU if we are not connected?
> > First check in the code is to check for a connection.
> I mentioned cooked monitor because putting the hw in monitor mode may
> not always be desirable, and cooked monitor bypasses that.

You can pass "flags none" on the iw command line and it shouldn't change
much then, but yeah, still might do a few other things. Anyway cooked
should work fine.

johannes

