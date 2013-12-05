Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab3LEPkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:40:45 -0500
Message-ID: <1386258040.4182.6.camel@jlt4.sipsolutions.net> (sfid-20131205_164048_159913_E6188662)
Subject: Re: [PATCH v2 1/3] nl80211: back to default bitrate_mask correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Thu, 05 Dec 2013 16:40:40 +0100
In-Reply-To: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100229_136461_336B8817)
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131205_100229_136461_336B8817)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 10:02 +0100, Janusz Dziedzic wrote:
> In case of empty NL80211_ATTR_TX_RATES attribute
> in nl80211_set_tx_bitrate_mask() function back to
> default bitrate mask, to be able to reset the
> state.

Applied 1 and 2.

johannes

