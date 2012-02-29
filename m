Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2B2UWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 15:22:10 -0500
Subject: Re: [PATCH] carl9170: fix breakage from "mac80211: handle
 non-bufferable MMPDUs correctly"
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1330546305-26773-1-git-send-email-linville@tuxdriver.com> (sfid-20120229_211710_789404_8C6CE13B)
References: <1330546305-26773-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20120229_211710_789404_8C6CE13B)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 21:22:03 +0100
Message-ID: <1330546923.13717.9.camel@jlt3.sipsolutions.net> (sfid-20120229_212214_402917_A17A1E79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 15:11 -0500, John W. Linville wrote:
> That commit intended for 3.4 renamed IEEE80211_TX_CTL_POLL_RESPONSE as
> IEEE80211_TX_CTL_NO_PS_BUFFER.  Meanwhile, "carl9170: fix frame delivery
> if sta is in powersave mode" added a reference to
> IEEE80211_TX_CTL_POLL_RESPONSE in the fixes stream for 3.3.  This simple
> patch fixes that merge boo-boo.

Thanks, sorry about the overlap.

johannes

