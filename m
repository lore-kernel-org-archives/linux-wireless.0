Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30696 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZLWCMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:12:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 18:12:50 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19249.32885.877602.60242@gargle.gargle.HOWL>
Date: Wed, 23 Dec 2009 07:59:09 +0530
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <20091222175939.GF4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL>
	<20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux>
	<20091222165528.GE4385@tux>
	<20091222175939.GF4385@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> I just tried adding the PM stuff over ath9k_remove_interface and I still get the
> issue. The patch is below.

The HW is not accessed in ->remove_interface(), so this patch is not necessary.

Sujith
