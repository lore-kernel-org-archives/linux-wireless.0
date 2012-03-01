Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44663 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723Ab2CAFyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 00:54:02 -0500
Received: by lahj13 with SMTP id j13so301487lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 21:54:01 -0800 (PST)
Message-ID: <4F4F0EE1.2020202@lacto.se> (sfid-20120301_065410_374101_5B74AF90)
Date: Thu, 01 Mar 2012 06:53:37 +0100
From: =?ISO-8859-1?Q?Kim_Lidstr=F6m?= <dexter@lacto.se>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: "Failed to stop Tx DMA" and "Could not stop RX" with AR9485
References: <4F4E9A36.2080809@lacto.se> <CAD2nsn2ifGDPr_J7LtBS04yCkxg12jQShrCDCBUERmOC5kodyA@mail.gmail.com>
In-Reply-To: <CAD2nsn2ifGDPr_J7LtBS04yCkxg12jQShrCDCBUERmOC5kodyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 06:09 AM, Mohammed Shafi wrote:
>> With this message I have attached a log with the error messages.
>> This has been a problem since.. Uhm.. Kernel 3.2.something and I'm
>> currently running 3.2.8.
>> For some reason it happened at least 3-4 times shortly after each other
>> today - so I thought I might ask on here what's happening.
> 
> disabling power save would be a nice idea,  to see if this issue disappears.
> i got the same issue after a long stress test with some other card, sujith
> gave me the idea to see if disabling PS helps
> sudo iwconfig wlanX power off
> sudo iw dev wlanX set power_save off
> also please ensure that you run with your power adapter :) i noticed
> PS gets enabled
> via wext when we plug out the power adapter
> 

I just tried it and will see what happens! That might take a while,
though, because it seems to occur at random.

But you know something? The thought has struck me before that it might
have something to do with power saving. Interesting :)

