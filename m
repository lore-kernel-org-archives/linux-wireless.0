Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbcHBIbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 04:31:17 -0400
Message-ID: <1470123892.2665.10.camel@sipsolutions.net> (sfid-20160802_103209_915595_270E4616)
Subject: Re: [PATCH] cfg80211: fix missing break in NL8211_CHAN_WIDTH_80P80
 case
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin King <colin.king@canonical.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 02 Aug 2016 09:44:52 +0200
In-Reply-To: <1468781727-9906-1-git-send-email-colin.king@canonical.com> (sfid-20160717_205612_900519_B3D51FBD)
References: <1468781727-9906-1-git-send-email-colin.king@canonical.com>
	 (sfid-20160717_205612_900519_B3D51FBD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-07-17 at 19:55 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The switch on chandef->width is missing a break on the
> NL8211_CHAN_WIDTH_80P80 case; currently we get a WARN_ON when
> center_freq2 is non-zero because of the missing break.
> 
Applied, thanks.

johannes
