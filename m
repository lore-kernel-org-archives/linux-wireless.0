Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41673 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbbIXObc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:31:32 -0400
Message-ID: <1443105090.1869.9.camel@sipsolutions.net> (sfid-20150924_163135_341568_BD2C12C5)
Subject: Re: [PATCH 4.3 1/2] mac80211: fix tx sequence number assignment
 with software queue + fast-xmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2015 16:31:30 +0200
In-Reply-To: <1443099589-69793-1-git-send-email-nbd@openwrt.org>
References: <1443099589-69793-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-09-24 at 14:59 +0200, Felix Fietkau wrote:
> When using software queueing, tx sequence number assignment happens 
> at
> ieee80211_tx_dequeue time, so the fast-xmit codepath must not do 
> that.
> 
Applied, but to mac80211-next since there's no driver in 4.3 yet that
actually uses ieee80211_tx_dequeue().

johannes
