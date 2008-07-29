Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:58885 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752068AbYG2M1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:27:20 -0400
Message-ID: <488F0C13.6050803@cortland.com> (sfid-20080729_142722_191284_7E917B5F)
Date: Tue, 29 Jul 2008 08:24:51 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: oops in cfg80211 doing mesh mpath dump
References: <488EF6E0.7050209@cortland.com>	 (sfid-20080729_125437_639538_96B3F8BB) <1217329761.10489.15.camel@johannes.berg>
In-Reply-To: <1217329761.10489.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-07-29 at 06:54 -0400, Steve Brown wrote:
>   
>> I added line numbers to the recursion path. If more are needed, let me know.
>>     
>
> Thanks, I have a fix already somewhere
>
> johannes
>   
Your patch set "[PATCH 0/3] mac80211 fixes" did the trick.

root@OpenWrt:/# iw dev mesh mpath dump
00:16:01:2e:0c:4c 00:16:01:2e:0c:4c mesh        3       4294967295      
0       208     100     0       0x4

Thanks,
Steve

