Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12298 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167AbbIKODV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2015 10:03:21 -0400
From: Chor Teck Law <ctlaw@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: David Lin <dlin@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH] Add new mac80211 driver mwlwifi.
Date: Fri, 11 Sep 2015 14:03:08 +0000
Message-ID: <9fcd82c278ea47cb915798ffc7bdcb0b@SC-EXCH03.marvell.com> (sfid-20150911_160325_310013_5D15C26D)
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	<1433598191.2467.65.camel@sipsolutions.net>
 <877fo3he8y.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fo3he8y.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Sunday, September 06, 2015 6:25 AM
> 
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Thu, 2015-06-04 at 04:57 +0000, David Lin wrote:
> >
> >>  drivers/net/wireless/mwlwifi/Kconfig        |   17 +
> >
> > Does this driver has any relation to mwifiex? Perhaps the same
> > maintainer team, etc.? 

The mwlwifi driver is hostmac supporting mac80211. The mwifiex driver is device/hw mac, that does not work with mac80211. They are both maintained by Marvell. Yes, their respective maintainers are connected under same teams.

> > Could consider moving all the Marvell drivers
> > into one directory, but not really necessary I guess.
> 
> Actually I would want to start adding vendor directories for wireless
> drivers, just like drivers/net/ethernet has, to cleanup the directory
> structure. So for example this driver we would have
> drivers/net/wireless/marvell/mwlwifi and later we would start moving
> existing drivers to vendor drivers as well. Thoughts?
> 

Yes, we are ok with this folder hierarchy change. Let us know how we can help. Should we start with this new folder now or wait for more feedbacks?

> --
> Kalle Valo
