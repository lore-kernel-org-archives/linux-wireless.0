Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38959 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbbK3NOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 08:14:34 -0500
Message-ID: <1448889271.3957.2.camel@sipsolutions.net> (sfid-20151130_141437_338500_641939B2)
Subject: Re: [PATCH] mac80211: allow drivers to report (non-)monitor frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2015 14:14:31 +0100
In-Reply-To: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com> (sfid-20151130_135514_150954_6D7D0B87)
References: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com>
	 (sfid-20151130_135514_150954_6D7D0B87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-30 at 13:54 +0100, Grzegorz Bajorski wrote:
> This allows drivers to tell mac80211 whether given
> frame is to be processed regularly but skip
> monitor interface delivery or vice versa.
> 
Can you give an example, and perhaps a corresponding driver patch?

johannes
