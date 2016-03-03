Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56392 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbcCCPDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:03:24 -0500
Message-ID: <1457017401.2044.16.camel@sipsolutions.net> (sfid-20160303_160328_337502_E3654ECA)
Subject: Re: [PATCH] nl80211: use ieee80211_band in kernel space
From: Johannes Berg <johannes@sipsolutions.net>
To: arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 03 Mar 2016 16:03:21 +0100
In-Reply-To: <56CEFA9C.1080201@broadcom.com> (sfid-20160225_135916_981057_E6AE3A89)
References: <1456399941-8408-1-git-send-email-arend@broadcom.com>
	 <56CEFA9C.1080201@broadcom.com> (sfid-20160225_135916_981057_E6AE3A89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-25 at 13:59 +0100, Arend Van Spriel wrote:
> On 25-2-2016 12:32, Arend van Spriel wrote:
> > The enumeration nl80211_band intends to expose the public part of
> > ieee80211_band enumeration. As such it should not be used in the
> > kernel. This patch changes nl80211_band usage to ieee80211_band.
> > 
> Fixes: 59ad2160c285 ("nl80211: add feature for BSS selection
> support")
> 
> Not sure if it is any of the trees already.
> 

I'm tempted to just get rid of ieee80211_band and move the NUM thing to
nl80211.h.

Thoughts?

johannes
