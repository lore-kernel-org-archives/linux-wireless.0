Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57201 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab2K2G2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 01:28:11 -0500
Message-ID: <50B70076.4070908@posedge.com> (sfid-20121129_072814_968997_5DD7537F)
Date: Thu, 29 Nov 2012 11:58:06 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add debugfs file for last rx rate
References: <1d88d390652318a8561e107f4254a920@posedge.com> <1353942634.2800.3.camel@jlt4.sipsolutions.net> <50B45980.3040703@posedge.com>
In-Reply-To: <50B45980.3040703@posedge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/27/2012 11:41 AM, Saravana wrote:
> On 11/26/2012 08:40 PM, Johannes Berg wrote:
>> On Mon, 2012-11-26 at 05:42 -0800, saravanad@posedge.com wrote:
>>> Add a debugfs file showing the rate at which
>>> the last packet is received.
>>
>> Same here, no need for a debugfs file.
>>
> As many of the statistics like rx/tx bytes/packet, tx retries, power etc
> are available in debugfs,for completeness and uniformity, thought of adding this to debugfs.
>> johannes
>>
Could last rx rate be added to debugfs?
Saravana
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

