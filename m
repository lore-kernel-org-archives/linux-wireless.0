Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GZGYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 02:24:23 -0400
Message-ID: <1343283856.4611.1.camel@jlt3.sipsolutions.net> (sfid-20120726_082426_812395_E27F9EB2)
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, ath5k-devel@venema.h4ckr.net,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	nbd@openwrt.org
Date: Thu, 26 Jul 2012 08:24:16 +0200
In-Reply-To: <1343244302.3750.44.camel@cumari.coelho.fi>
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>
	 (sfid-20120725_113644_599580_8AC4476F) <1343220625.4463.31.camel@jlt3.sipsolutions.net>
	 <500FEDDD.206@net.t-labs.tu-berlin.de>
	 <1343244302.3750.44.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 22:25 +0300, Luciano Coelho wrote:

> > My last PATCH included some changes at a TI driver which was adapted in
> > wireless-testing in John's tree. As I touch that many drivers I would
> > like to use your tree instead, to provide a proper PATCH that builds at
> > your tree state...small de-synchronization issues just make it fail.
> 
> Since Johannes has already more or less acked this patch, wouldn't it be
> easier to integrate via John's tree? I think it would make syncing with
> mac80211 and all the drivers easier.

That wouldn't have helped, I actually merged wireless-next and wireless
before applying the patch, so it just overlapped with other changes
between Thomas's testing and applying it.

johannes

