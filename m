Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36967 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2CAFJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 00:09:56 -0500
Received: by vcqp1 with SMTP id p1so180394vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 21:09:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4E9A36.2080809@lacto.se>
References: <4F4E9A36.2080809@lacto.se>
Date: Thu, 1 Mar 2012 10:39:55 +0530
Message-ID: <CAD2nsn2ifGDPr_J7LtBS04yCkxg12jQShrCDCBUERmOC5kodyA@mail.gmail.com> (sfid-20120301_061038_169931_67F924F8)
Subject: Re: "Failed to stop Tx DMA" and "Could not stop RX" with AR9485
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?Q?Kim_Lidstr=F6m?= <dexter@lacto.se>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Adrian Chadd <adrian.chadd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> With this message I have attached a log with the error messages.
> This has been a problem since.. Uhm.. Kernel 3.2.something and I'm
> currently running 3.2.8.
> For some reason it happened at least 3-4 times shortly after each other
> today - so I thought I might ask on here what's happening.

disabling power save would be a nice idea,  to see if this issue disappears.
i got the same issue after a long stress test with some other card, sujith
gave me the idea to see if disabling PS helps
sudo iwconfig wlanX power off
sudo iw dev wlanX set power_save off
also please ensure that you run with your power adapter :) i noticed
PS gets enabled
via wext when we plug out the power adapter

-- 
thanks,
shafi
