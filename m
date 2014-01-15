Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaAONfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:35:38 -0500
Message-ID: <1389792934.4338.13.camel@jlt4.sipsolutions.net> (sfid-20140115_143541_880068_16D37CA7)
Subject: Re: [PATCH 1/3] cfg80211: Allow BSS hint to be provided for connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:35:34 +0100
In-Reply-To: <20140114220047.GA19671@w1.fi>
References: <20140114220047.GA19671@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 00:00 +0200, Jouni Malinen wrote:
> This clarifies the expected driver behavior on the older
> NL80211_ATTR_MAC and NL80211_ATTR_WIPHY_FREQ attributes and adds a new
> set of similar attributes with _HINT postfix to enable use of a
> recommendation of the initial BSS to choose. This can be helpful for
> some drivers that can avoid an additional full scan on connection
> request if the information is provided to them (user space tools like
> wpa_supplicant already has that information available based on earlier
> scans).

Applied.

johannes

