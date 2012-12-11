Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38494 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2LKR0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 12:26:47 -0500
Message-ID: <50C76CD6.1090902@openwrt.org> (sfid-20121211_182700_810189_FE039B18)
Date: Tue, 11 Dec 2012 18:26:46 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] ath9k: check pdata variable before dereferencing it
References: <1355246740-12539-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1355246740-12539-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.11. 18:25 keltezéssel, Gabor Juhos írta:
> Due to my recent commit (ath9k: allow to load EEPROM
> content via firmware API) smatch complains about that
> the 'pdata' variable in 'ath9k_hw_init' can be NULL
> and it is dereferenced before checking that. That is
> absolutely correct.
> 
> Check the 'pdata' variable before using it to avoid
> a NULL pointer dereference.

Oops, sent an old patch again instead of the rt2x00 one. Sorry.

-Gabor
