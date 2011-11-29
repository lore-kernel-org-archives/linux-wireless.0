Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1K2IW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 03:22:59 -0500
Subject: Re: pull request: wireless-next 2011-11-28
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20111128200221.GD2681@tuxdriver.com> (sfid-20111128_211553_792888_D5B25BB4)
References: <20111128200221.GD2681@tuxdriver.com>
	 (sfid-20111128_211553_792888_D5B25BB4)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:22:52 +0100
Message-ID: <1322554972.4110.0.camel@jlt3.sipsolutions.net> (sfid-20111129_092305_020101_25A2E6BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 15:02 -0500, John W. Linville wrote:

> Johannes Berg (12):

>       mac80211: use skb list for fragments
>       mac80211: move fragment flag adjustment
>       mac80211: make TX LED handling independent of fragmentation
>       mac80211: transmit fragment list to drivers

Since you included these patches, can you please pick up "mac80211: fix
TX warning" relatively quickly? It fixes a harmless but possibly
recurring WARN_ON in this code.

johannes

