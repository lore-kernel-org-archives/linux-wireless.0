Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49768 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKFWbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 17:31:13 -0500
Message-ID: <1415313070.17015.19.camel@sipsolutions.net> (sfid-20141106_233116_379164_B8B2B0FA)
Subject: Re: Vendor Namespace Question
From: Johannes Berg <johannes@sipsolutions.net>
To: "C. McPherson" <ccmcphe@verizon.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@radiotap.org
Date: Thu, 06 Nov 2014 23:31:10 +0100
In-Reply-To: <5459349F.9020903@verizon.net>
References: <54591CF9.7030106@verizon.net>
	 (sfid-20141104_203850_228702_C706EE9A) <1415130476.2064.22.camel@sipsolutions.net>
	 <5459349F.9020903@verizon.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 15:18 -0500, C. McPherson wrote:
> Thanks so much for the info Johannes. I did notice that rx_status was 
> getting full.  I'll go ahead and put it in skb->data, that's a good idea.

I just sent a patch to restore vendor radiotap stuff in mac80211.

Works for me, and I might actually have a use case for it, but please
tell me if you have issues with it.

johannes

