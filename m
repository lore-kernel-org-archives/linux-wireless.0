Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46403 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2GNGFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 02:05:30 -0400
Date: Fri, 13 Jul 2012 23:05:26 -0700 (PDT)
Message-Id: <20120713.230526.350857505278321316.davem@davemloft.net> (sfid-20120714_080615_844999_6A845EFD)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-07-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120712181539.GB25494@tuxdriver.com>
References: <20120712181539.GB25494@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 12 Jul 2012 14:15:40 -0400

> Several drivers see updates: mwifiex, ath9k, iwlwifi, brcmsmac,
> wlcore/wl12xx/wl18xx, and a handful of others.  The bcma bus got a
> lot of attention from Hauke Mehrtens.  The cfg80211 component gets
> a flurry of patches for multi-channel support, and the mac80211
> component gets the first few VHT (11ac) and 60GHz (11ad) patches.
> This also includes the removal of the iwmc3200 drivers, since the
> hardware never became available to normal people.
> 
> Additionally, the NFC subsystem gets a series of updates.  According to
> Samuel, "Here are the interesting bits:
> 
> - A better error management for the HCI stack.
> - An LLCP "late" binding implementation for a better NFC SAP usage. SAPs are
>   now reserved only when there's a client for it.
> - Support for Sony RC-S360 (a.k.a. PaSoRi) pn533 based dongle. We can read and
>   write NFC tags and also establish a p2p link with this dongle now.
> - A few LLCP fixes."
> 
> Finally, this includes another pull of the fixes from the wireless
> tree in order to resolve some merge issues.

Pulled, thanks John.
