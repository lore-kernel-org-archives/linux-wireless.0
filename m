Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58520 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbZBOPoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 10:44:23 -0500
Date: Sun, 15 Feb 2009 17:44:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
Message-ID: <20090215154408.GA6845@jm.kir.nu> (sfid-20090215_164431_166367_FACC0EC3)
References: <20090213105306.GA18754@jm.kir.nu> <1234522804.4219.13.camel@johannes.local> <20090213111523.GA22438@jm.kir.nu> <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 03:09:15PM +0200, Tomas Winkler wrote:
> Status questions
> What is the version of wpa_supplicant that supports WPS.  Is wext
> covered with IWEVGENIE?

wpa_supplicant 0.6.7 and newer has support for WPS, but there are some
bug fixes since then, so 0.6.8 is likely a better starting point. wext
works for most parts, but there is no support for adding WPS IE into
Probe Request with it (cfg80211/nl80211 needed for this). Anyway, that
part of the protocol is optional, so it should not cause major problems.

> Is it currently working with mac80211 based drivers?

Yes.

-- 
Jouni Malinen                                            PGP id EFC895FA
