Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33434 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbbLKONE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 09:13:04 -0500
Message-ID: <1449843182.2324.8.camel@sipsolutions.net> (sfid-20151211_151310_682544_37E21418)
Subject: Re: [RFC] mac80211: ignore AP power level when tx power type is
 "fixed"
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Fri, 11 Dec 2015 15:13:02 +0100
In-Reply-To: <1449324423-99589-1-git-send-email-nbd@openwrt.org>
References: <1449324423-99589-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-12-05 at 15:07 +0100, Felix Fietkau wrote:
> In some cases a user might want to connect to a far away access
> point,
> which announces a low tx power limit. Using the AP's power limit can
> make the connection significantly more unstable or even impossible,
> and
> mac80211 currently provides no way to disable this behavior.
> 
> To fix this, use the currently unused distinction between limited and
> fixed tx power to decide whether a remote AP's power limit should be
> accepted.
> 
This seems reasonable. Maybe we should document it though?

johannes
