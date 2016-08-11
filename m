Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51226 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbcHKH6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 03:58:20 -0400
Message-ID: <1470902295.5266.8.camel@sipsolutions.net> (sfid-20160811_095827_021780_F351A9D7)
Subject: Re: pull-request: mac80211 2016-08-05
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 09:58:15 +0200
In-Reply-To: <1470400329-23256-1-git-send-email-johannes@sipsolutions.net> (sfid-20160805_143231_516679_202A0463)
References: <1470400329-23256-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20160805_143231_516679_202A0463)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-05 at 14:32 +0200, Johannes Berg wrote:
> Hi Dave,
> 
> Here's a first set of fixes for the current cycle. See the tag
> message
> for more information.
> 
> I'll probably have a follow-up fix for the real problem in mac80211
> that caused the crash later, but for now we have this patch and it
> makes sense and fixes the crash, even if the behaviour isn't quite
> right (afaict.)
> 

Just FYI, I'm going to "defer" the fix for the wrong behaviour to
mac80211-next since no driver is affected by it.

johannes
