Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail12.tpgi.com.au ([203.12.160.162]:36693 "EHLO
	mail12.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXKSMLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 07:11:49 -0500
Message-ID: <47417D7F.3060704@hotmail.com> (sfid-20071119_121156_656993_D05F9C02)
Date: Mon, 19 Nov 2007 23:11:43 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	   Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net>
In-Reply-To: <20071119.002755.77617097.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
>> If I try to scan for APs using iwlist, I get one AP listed, before a bus 
>> error occurs. This of course, does not suggest that the problem is with 
>> the driver, but I mention it for the record.
> 
> This is an unaligned data access in the userland tools.
> Try to catch it with GDB and give us ths backtrace.

I will try and do this at some point. Unfortunately, the system isn't 
readily at hand, and it might take a couple of days before I am able to 
attend to it.

>> Whilst the device is up, I continually get console messages like those I 
>> have inlined below:
>>
>> Kernel unaligned access at TPC[100ee4d4] do_rx+0x244/0x614 [zd1211rw]
>> Kernel unaligned access at TPC[100ee4e8] do_rx+0x258/0x614 [zd1211rw]
>> Kernel unaligned access at TPC[100ee4cc] do_rx+0x23c/0x614 [zd1211rw]
> 
> These are unaligned data accesses in the kernel driver.

Sure. Just to make sure I understand, does TPC stand for something like 
Trap Program Code?

