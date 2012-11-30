Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:33750 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab2K3H5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 02:57:40 -0500
Message-ID: <50B866E9.20406@posedge.com> (sfid-20121130_085743_501234_D738ACF3)
Date: Fri, 30 Nov 2012 13:27:29 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for last rx rate
References: <50B77013.6040508@posedge.com> <1354199652.879.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354199652.879.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 08:04 PM, Johannes Berg wrote:
> On Thu, 2012-11-29 at 19:54 +0530, Saravana wrote:
>> Add a debugfs file showing the rate at which
>> the last packet is received.
> 
> Applied, but:
> 
>> +static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
>> +				      size_t count, loff_t *ppos)
> 
> fixed indentation here
> 
> 
>> +	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d MBit/s\n",
>> +					rate/10, rate%10);
> 
> and here
> 
> (and also a bunch of whitespace changes in the other patches)
> 

Thanks Johannes for taking care of modifications. Will take care of indentation and the whitespace issues in future.
> johannes
> 
> 

