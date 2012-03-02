Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:34159 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030283Ab2CBPp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 10:45:26 -0500
Message-ID: <4F50EB14.2060206@stericsson.com> (sfid-20120302_164529_192959_5B4C8D62)
Date: Fri, 2 Mar 2012 16:45:24 +0100
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 21/21] cw1200: Kconfig + Makefile for the driver.
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>  <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>  <1330652495-25837-22-git-send-email-dmitry.tarnyagin@stericsson.com>  (sfid-20120302_024231_185549_5ECA663F) <1330678213.8542.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330678213.8542.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I fixed most of comments and cleaned up Kconfig a bit, will resubmit the 
patchset soon.
>> +config CW1200_BH_DEBUG
>> +      bool "Enable low-level device communication logs (DEVELOPMENT)"
>> +      help
>> +        Say Y if you want to enable BH logs.
>> +        If unsure, say N.
> What does "BH" stand for here? In the kernel it typically stands for
> Bottom Half (or softirq) but that can't be meant? In other places in
> your code you do mean that though, it seems, so this is a bit confusing.
Well, I see it was a big mistake to call serving thread "bh" :). 
Starting this project
once again I would not do it like that. But it is difficult to rename it 
all around
the code now, just because the code is published already on Igloo.

> You should think about adding tracing instead.
Good point. I added it to TODO list.

Dmitry
