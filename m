Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36902 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYL2MW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 07:22:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: clean up set_key callback
Date: Mon, 29 Dec 2008 13:22:09 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1230551709.3116.30.camel@johannes>
In-Reply-To: <1230551709.3116.30.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812291322.10083.mb@bu3sch.de> (sfid-20081229_132302_097407_F55BA017)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 December 2008 12:55:09 Johannes Berg wrote:
> The set_key callback now seems rather odd, passing a MAC address
> instead of a station struct, and a local address instead of a
> vif struct. Change that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Acked-by: Bob Copeland <me@bobcopeland.com> [ath5k]
> Acked-by: Ivo van Doorn <ivdoorn@gmail.com> [rt2x00]
> Acked-by: Christian Lamparter <chunkeey@web.de> [p54]
> Tested-by: Kalle Valo <kalle.valo@nokia.com> [iwl3945]
> Tested-by: Samuel Ortiz <samuel@sortiz.org> [iwl3945]

ACK

-- 
Greetings, Michael.
