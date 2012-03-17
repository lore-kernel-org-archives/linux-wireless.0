Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:44645 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab2CQVTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 17:19:43 -0400
Date: Sat, 17 Mar 2012 14:18:30 -0700 (PDT)
Message-Id: <20120317.141830.1341064825746942134.davem@davemloft.net> (sfid-20120317_221948_022398_0F522B09)
To: Larry.Finger@lwfinger.net
Cc: joe@perches.com, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rtlwifi: Use is_zero_ether_addr, remove line
 continuation
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F64FECD.9000802@lwfinger.net>
References: <1d738d4a4dd61978f969ed4a43f2dd3717f51a19.1332011552.git.joe@perches.com>
	<4F64FECD.9000802@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 17 Mar 2012 16:14:53 -0500

> On 03/17/2012 02:13 PM, Joe Perches wrote:
>> Use the normal kernel facilities and use %pM
>> to print the all zero mac address.
>>
>> Remove unnecessary line continuation.
>>
>> Signed-off-by: Joe Perches<joe@perches.com>
>> ---
>>   drivers/net/wireless/rtlwifi/cam.c |    5 ++---
>>   1 files changed, 2 insertions(+), 3 deletions(-)
> 
> ACKed-by: Larry.Finger@lwfinger.net
> 
> Is there a PATCH 2/2? I did not receive it.

It went to netdev only and was only for non-wireless networking
drivers.
