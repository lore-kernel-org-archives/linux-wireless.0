Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41659 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbbIXO3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:29:10 -0400
Message-ID: <1443104948.1869.8.camel@sipsolutions.net> (sfid-20150924_162914_134945_03A3206A)
Subject: Re: [PATCH 4.3 2/2] mac80211: fix handling of PS filtering with
 fast-xmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2015 16:29:08 +0200
In-Reply-To: <1443099589-69793-2-git-send-email-nbd@openwrt.org>
References: <1443099589-69793-1-git-send-email-nbd@openwrt.org>
	 <1443099589-69793-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-09-24 at 14:59 +0200, Felix Fietkau wrote:
> Fixes dropped packets in the tx path in case a non-PS station 
> triggers
> the tx filter.
> 
Applied, but without the stable tag since no driver in 4.2 that uses
IEEE80211_TX_CTL_CLEAR_PS_FILT also had FAST_XMIT.

johannes
