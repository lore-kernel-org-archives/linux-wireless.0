Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:55997 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932934Ab2GYNAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 09:00:15 -0400
Message-ID: <500FEDDD.206@net.t-labs.tu-berlin.de> (sfid-20120725_150026_327005_C3B5841F)
Date: Wed, 25 Jul 2012 15:00:13 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>  (sfid-20120725_113644_599580_8AC4476F) <1343220625.4463.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343220625.4463.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:


>> Finally applied, but I dropped these spurious changes:
> Never mind, it still doesn't compile, dropped it.
>
> I had to rebase my tree due to that, sorry!
>

My last PATCH included some changes at a TI driver which was adapted in
wireless-testing in John's tree. As I touch that many drivers I would
like to use your tree instead, to provide a proper PATCH that builds at
your tree state...small de-synchronization issues just make it fail.

Can I use your wireless-next for that at:
linux/kernel/git/jberg/mac80211-next.git .. or any other suggestion ?

Greetings Thomas
