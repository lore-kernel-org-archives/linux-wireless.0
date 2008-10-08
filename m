Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2530 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYJHAOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 20:14:32 -0400
Subject: Re: [PATCH] p54: Fix compilation problem on PPC
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>, Chr <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223398653.7328.43.camel@johannes.berg>
References: <48EB7FF1.9060803@lwfinger.net>
	 <1223398653.7328.43.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 20:14:29 -0400
Message-Id: <1223424869.22522.6.camel@dv> (sfid-20081008_021436_821950_7B056A67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-07 at 18:57 +0200, Johannes Berg wrote:

> No, I don't have a device, was just compiling, sorry. Is there any on
> the market that isn't too expensive that I could get?

I'm sorry for being late.  I have tested an Xterasys XG-600 (miniPCI) on
i386 and PowerPC.  The same device is working on i386, but not on
PowerPC.  There are kernel messages running on the console on PowerPC,
but I could not capture them yet.  The kernel is the current
wireless-testing.

I also tested D-Link DWL-G650 (CardBus), but it appears to be
unreliable.  I could scan only once with it on i386.  Most time scanning
won't find any APs.

I suspect we should not be mixing little-endian and host-endian
structures.

-- 
Regards,
Pavel Roskin
