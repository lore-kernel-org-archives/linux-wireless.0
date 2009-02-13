Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25388 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZBMFPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:15:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:15:18 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18837.258.441789.724160@gargle.gargle.HOWL> (sfid-20090213_061528_289949_D122DEFC)
Date: Fri, 13 Feb 2009 10:41:30 +0530
To: Sujith Manoharan <Sujith.Manoharan@Atheros.com>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	<Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: fix aggregation for hardware with ampdu queues
In-Reply-To: <18836.65353.489754.511505@gargle.gargle.HOWL>
References: <1234396313.16004.65.camel@johannes.local>
	<18835.43402.286764.192456@gargle.gargle.HOWL>
	<E9954878DD1FB34FAE5187FB88C58A353F1ACF4B@orsmsx506.amr.corp.intel.com>
	<18836.65353.489754.511505@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> Guy, Wey-Yi W wrote:
> > Thanks for testing. Do you agree the medium-term sulution?
> >

Sorry, I thought you meant the immediate interim solution.

The medium-term plan outlined is bound to affect ath9k ( which does
internal bookkeeping ). Am not sure right now what the ramifications would
be until we get a chance to look at code which introduces buffering
in mac80211.

Sujith
