Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47622 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZH2Bfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 21:35:31 -0400
Message-ID: <4A9885DC.4030105@openwrt.org>
Date: Sat, 29 Aug 2009 03:35:24 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use
 in	ath5k_eeprom_read_turbo_modes()
References: <20090827023000.21926.90867.stgit@mj.roinet.com>	<40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>	<b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>	<43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>	<20090827213921.GB30419@hash.localnet>	<43e72e890908271614p58feb9bn2130e1c963685a55@mail.gmail.com> <20090828154410.GB32694@tuxdriver.com>
In-Reply-To: <20090828154410.GB32694@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I think I am on the side of removing the non-standard extensions.
> FWIW, I'll need a patch posted with a proper Subject and
> Signed-off-by...
> 
> I think Nick has some valid points.  His position sounds similar to
> that expressed to me by Felix and some others that it would be nice
> if we could more easily accomodate some of the features of madwifi
> that have made it attractive to researchers and experimenters.
> Perhaps NL80211_CMD_TESTMODE relates to this desire?
Yes, that would be a good solution. I know a lot of people who are going
continue to stick with madwifi if they won't be able to use turbo mode
with ath5k. Since quite a few of those people are using OpenWrt, it
would also mean that I would have to continue to maintain my madwifi
semi-fork in OpenWrt even longer, and I definitely want to avoid that.

- Felix
