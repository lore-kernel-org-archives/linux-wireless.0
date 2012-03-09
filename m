Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2CINZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 08:25:41 -0500
Subject: Re: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses
 static SMPS
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
In-Reply-To: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120309_141428_440266_4DD1AD56)
References: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20120309_141428_440266_4DD1AD56)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 14:25:38 +0100
Message-ID: <1331299538.3491.4.camel@jlt3.sipsolutions.net> (sfid-20120309_142544_291169_CDDEE3D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 14:13 +0100, Helmut Schaa wrote:
> Disable multi stream rates (MCS > 7) when a STA is in static SMPS mode
> since it has only one active rx chain. Hence, it doesn't even make
> sense to sample multi stream rates.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> I haven't found a STA that makes use of static SMPS, so this is only compile tested.

You can easily make a mac80211 use it with the debugfs file?

johannes

