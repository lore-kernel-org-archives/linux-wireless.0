Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:38478 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbbAHHqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 02:46:34 -0500
Message-ID: <54AE3588.6040100@windriver.com> (sfid-20150108_084640_553347_F6B8C1D9)
Date: Thu, 8 Jan 2015 15:45:12 +0800
From: Ying Xue <ying.xue@windriver.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next] mac80211: silent build warnings
References: <1420700655-9427-1-git-send-email-ying.xue@windriver.com> <1420702907.2029.2.camel@sipsolutions.net>
In-Reply-To: <1420702907.2029.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2015 03:41 PM, Johannes Berg wrote:
> On Thu, 2015-01-08 at 15:04 +0800, Ying Xue wrote:
>> Silent the following build warnings:
>>
>> net/mac80211/mlme.c: In function ‘ieee80211_rx_mgmt_beacon’:
>> net/mac80211/mlme.c:1348:3: warning: ‘pwr_level_cisco’ may be used uninitialized in this function [-Wuninitialized]
>> net/mac80211/mlme.c:1315:6: note: ‘pwr_level_cisco’ was declared here
> 
> We seem to get this every year or so... just upgrade your compiler and
> it will be smart enough to prove that it's wrong here.
> 
> I really *don't* want to shut up the compiler forcefully since it will
> cause modern compilers to *not* warn if it actually *is* unused - and 0
> is not a useful value - this code is tricky enough and we want compiler
> help in case we need to modify it in the future.
> 

Thank for your explanation, and please ignore the noise.

Regards,
Ying

> johannes
> 
> 
> 

