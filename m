Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li235-22.members.linode.com ([173.255.225.22]:51396 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1ETV1n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 17:27:43 -0400
Message-ID: <4DD6DCCC.2080106@erley.org> (sfid-20110520_232746_671520_5FA5EB6A)
Date: Fri, 20 May 2011 17:27:40 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: wwguy <wey-yi.w.guy@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn log spam
References: <4DD6D573.2060800@erley.org> <1305925719.1444.11.camel@wwguy-ubuntu>
In-Reply-To: <1305925719.1444.11.camel@wwguy-ubuntu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2011 05:08 PM, wwguy wrote:
> Hi Pat,
> 
> 
> Just want to be clear, which message flooding your system?
> is 
> iwlagn 0000:03:00.0: Aggregation not enabled for tid
>> 0 because load = 9

This I only see occasionally.

> or
> iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:0c:42:64:bb:1d
>> tid = 0

This message is the one that I've gotten over 1600 of in 16 hours.

>>
> the second message should only show once when the aggregation being establish. if you are seeing it every 35 seconds, that is bad. 
> but the first message is checking the traffic load is high enough to establish the aggregation queue, which is ok.
> and we should not log this type of message as "ERROR", I will submit a patch to change that.
> 

Feel free to include me in on the CC for that patch.  Will test.

Pat
