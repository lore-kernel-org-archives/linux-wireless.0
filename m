Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJURjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 13:39:00 -0400
Date: Tue, 21 Oct 2008 13:38:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] make ieee80211 invisible
Message-ID: <20081021173815.GH17268@tuxdriver.com> (sfid-20081021_193906_513662_B1F96EC6)
References: <1224006562.10113.47.camel@johannes.berg> <1224586015.5521.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224586015.5521.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 12:46:55PM +0200, Johannes Berg wrote:
> On Tue, 2008-10-14 at 19:49 +0200, Johannes Berg wrote:
> > 
> > This makes CONFIG_IEEE80211 invisible. The drivers that require it
> > (ipw2100, ipw2200, hostap) select it, and everybody else really
> > shouldn't even think about using it. Also, since there really is
> > no point in compiling anything without crypto support these days,
> > remove the crypto options and just enable them, leaving only the
> > debugging option which only shows up when a driver is select that
> > requires it. This makes it hard to enable, but most people wouldn't
> > want to anyway.
> 
> Do I have to repost to upgrade from [RFC] to [PATCH]?

This is fine, thanks. :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
