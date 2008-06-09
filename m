Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:59004 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYFIUYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 16:24:33 -0400
Date: Mon, 9 Jun 2008 13:24:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] mac80211: send association event on IBSS
	create
Message-ID: <20080609202404.GN30402@sequoia.sous-sol.org> (sfid-20080609_222435_612544_3B401E85)
References: <1212543981.4237.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212543981.4237.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams (dcbw@redhat.com) wrote:
> Otherwise userspace has no idea the IBSS creation succeeded.

Please resend when this hits upstream, and include the upstream commit
ID.  The easiest way to achieve this is to add "Cc: <stable@kernel.org>"
to the commit log so it gets routed to us upon commit upstream.

> Signed-off-by: Dan Williams <dcbw@redhat.com>
> -------------
> 
> John, please apply to 2.6.26 and later.
> 
> Stable: applicable to 2.6.24 and 2.6.25 as well.  File used to be called
> net/mac80211/ieee80211_sta.c and diff should still apply with minor
> fuzz.
