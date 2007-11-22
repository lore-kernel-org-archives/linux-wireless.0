Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3817 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXKVN1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 08:27:20 -0500
Date: Thu, 22 Nov 2007 08:26:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: mac80211 regression: doesn't associate automatically
Message-ID: <20071122132635.GA3372@tuxdriver.com> (sfid-20071122_132723_291781_42416AF0)
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <1195736752.6323.97.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195736752.6323.97.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2007 at 02:05:52PM +0100, Johannes Berg wrote:

> > Note that the same happens if I let Debian manage the card. An excerpt
> > from my /etc/network/interfaces shows:
> 
> That sucks, I guess debian's scripts need to be fixed.

As it stands, setting the SSID is the closest thing we have to an
"associate now" trigger.  I would have to advise distros and users to
always set it last in the wireless init, just before running dhclient
or whatever.

John
-- 
John W. Linville
linville@tuxdriver.com
