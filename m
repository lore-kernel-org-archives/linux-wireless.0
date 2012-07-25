Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47593 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab2GYTZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 15:25:14 -0400
Received: by lbol5 with SMTP id l5so942516lbo.34
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 12:25:11 -0700 (PDT)
Message-ID: <1343244302.3750.44.camel@cumari.coelho.fi> (sfid-20120725_212524_852041_26A30045)
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Luciano Coelho <coelho@ti.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	ath5k-devel@venema.h4ckr.net, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, nbd@openwrt.org
Date: Wed, 25 Jul 2012 22:25:02 +0300
In-Reply-To: <500FEDDD.206@net.t-labs.tu-berlin.de>
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	  (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>
	  (sfid-20120725_113644_599580_8AC4476F) <1343220625.4463.31.camel@jlt3.sipsolutions.net>
	 <500FEDDD.206@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 15:00 +0200, Thomas Huehn wrote:
> Hi Johannes,

Hi guys,


> Johannes Berg schrieb:
> >> Finally applied, but I dropped these spurious changes:
> > Never mind, it still doesn't compile, dropped it.
> >
> > I had to rebase my tree due to that, sorry!
> >
> 
> My last PATCH included some changes at a TI driver which was adapted in
> wireless-testing in John's tree. As I touch that many drivers I would
> like to use your tree instead, to provide a proper PATCH that builds at
> your tree state...small de-synchronization issues just make it fail.

Since Johannes has already more or less acked this patch, wouldn't it be
easier to integrate via John's tree? I think it would make syncing with
mac80211 and all the drivers easier.

Just my 2 cents.

--
Luca.

