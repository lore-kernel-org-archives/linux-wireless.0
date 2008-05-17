Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:50579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYEQSci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 14:32:38 -0400
Message-ID: <20080517203237.zjc3jex50kscwgo0@imap.suse.de> (sfid-20080517_203246_617783_2DBC9593)
Date: Sat, 17 May 2008 20:32:37 +0200
From: Helmut Schaa <hschaa@suse.de>
To: Helmut Schaa <hschaa@suse.de>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
References: <20080517202020.1da5y31wckkwc0sk@imap.suse.de>
In-Reply-To: <20080517202020.1da5y31wckkwc0sk@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sa 17 Mai 2008 20:20:20 CEST schrieb Helmut Schaa <hschaa@suse.de>:

> Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> introduced in the patch "mac80211: fix association with some APs".
>
> Signed-off-by: Helmut Schaa <hschaa@suse.de>
> ---
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 76ad4ed..2642551 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -664,15 +664,22 @@ static int ieee80211_compatible_rates(struct
> ieee80211_sta_bss *bss,

That should be on one line of course. Used a web-mail interface :(

I'll resend the patch in one minute.
