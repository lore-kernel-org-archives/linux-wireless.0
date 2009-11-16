Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:48947 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZKPKno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 05:43:44 -0500
Message-ID: <20091116124348.15263bv5mw8z5hwg@hayate.sektori.org>
Date: Mon, 16 Nov 2009 12:43:48 +0200
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
References: <20091116095653.17419.49151.stgit@fate.lan>
	<1258366924.32159.11.camel@johannes.local>
In-Reply-To: <1258366924.32159.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Johannes Berg" <johannes@sipsolutions.net>:

>
> Will that try open and shared though?
>

No, I'll post v2 which uses NDIS_80211_AUTH_AUTO_SWITCH instead.

-jussi

