Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60567 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYKZFVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 00:21:49 -0500
Cc: Henning Rogge <hrogge@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com> (sfid-20081126_062153_794921_648CAB1D)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1227646037.4613.46.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: RFC Patch: Add signal strength to nl80211station info
Date: Wed, 26 Nov 2008 06:21:40 +0100
References: <200811252131.30161.hrogge@googlemail.com> (sfid-20081125_213139_680674_17E7A0BB) <1227646037.4613.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> +	NL80211_STA_INFO_SIGNAL,
>> +	NL80211_STA_INFO_NOISE,
>> +	NL80211_STA_INFO_QUAL,
>
> Sorry, no, this WEXT junk is just too undefined to put it into  
> nl80211.

I know that WEXT were pretty bad in describing what to expect from  
these values and every driver did whatever it thought it would be  
best. Can we not just try to define how these values should be filled  
in and then either mark drivers as broken or try to fix them? Just an  
idea.

Regards

Marcel

