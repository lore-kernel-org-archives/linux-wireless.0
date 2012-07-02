Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2GBM6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:58:41 -0400
Message-ID: <1341233919.19642.7.camel@jlt3.sipsolutions.net> (sfid-20120702_145844_754180_8FB56CAA)
Subject: Re: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 02 Jul 2012 14:58:39 +0200
In-Reply-To: <1341233662.19642.6.camel@jlt3.sipsolutions.net> (sfid-20120702_145426_223571_E2B6D41B)
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341233662.19642.6.camel@jlt3.sipsolutions.net>
	 (sfid-20120702_145426_223571_E2B6D41B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 14:54 +0200, Johannes Berg wrote:
> On Mon, 2012-07-02 at 09:32 +0300, Vladimir Kondratiev wrote:
> > These patches add minimal infrastructure for the 60gHz (802.11ad)
> > band WiFi drivers.
> > 
> > This change enables offload drivers for the 60GHz devices that implement
> > the 802.11 MAC functionality in the device itself.
> > 
> > Driver based on this infrastructure see at:
> > http://wireless.kernel.org/en/users/Drivers/wil6210
> > 
> > Identation should be fine now, thanks Joe Perches for hint.
> > 
> > I put in #if 0 one entry in MCS-to-bitrate translation table,
> > since it does not fit into u16. It should work fine until
> > real devices with 6.5Gbps bitrate appears.
> > 
> > Vladimir Kondratiev (5):
> >   wireless: add 802.11ad (60gHz band)
> >   wireless: rate check logic for 60g
> >   wireless: regulatory for 60g
> >   wireless: 60g protocol constants
> >   wireless: bitrate calculation for 60g
> 
> Applied the first four patches, but I fixed the subjects for you (this
> time)

And I had to squash patches to make it compile without warnings after
each patch.

Please be more careful next time.

johannes

