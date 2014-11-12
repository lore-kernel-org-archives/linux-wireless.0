Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173023pub.verizon.net ([206.46.173.23]:12540 "EHLO
	vms173023pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLUze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 15:55:34 -0500
Received: from [192.168.1.5] ([108.28.174.148]) by vms173023.mailsrvcs.net
 (Oracle Communications Messaging Server 7.0.5.32.0 64bit (built Jul 16 2014))
 with ESMTPA id <0NEY00ATC241CS50@vms173023.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Wed, 12 Nov 2014 14:55:14 -0600 (CST)
Message-id: <5463C931.6000502@verizon.net> (sfid-20141112_215537_816112_C3866537)
Date: Wed, 12 Nov 2014 15:55:13 -0500
From: "C. McPherson" <ccmcphe@verizon.net>
MIME-version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@radiotap.org
Subject: Re: Vendor Namespace Question
References: <54591CF9.7030106@verizon.net>
 (sfid-20141104_203850_228702_C706EE9A)
 <1415130476.2064.22.camel@sipsolutions.net>	<5459349F.9020903@verizon.net>
 <1415313070.17015.19.camel@sipsolutions.net>
In-reply-to: <1415313070.17015.19.camel@sipsolutions.net>
Content-type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been off for a while, but I will download it and use it. Thanks 
Johannes!!


On 11/06/2014 05:31 PM, Johannes Berg wrote:
> On Tue, 2014-11-04 at 15:18 -0500, C. McPherson wrote:
>> Thanks so much for the info Johannes. I did notice that rx_status was
>> getting full.  I'll go ahead and put it in skb->data, that's a good idea.
> I just sent a patch to restore vendor radiotap stuff in mac80211.
>
> Works for me, and I might actually have a use case for it, but please
> tell me if you have issues with it.
>
> johannes
>
>

