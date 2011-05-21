Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1EUQyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2011 12:54:35 -0400
Subject: Re: iwlagn log spam
From: wwguy <wey-yi.w.guy@intel.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DD6DCCC.2080106@erley.org>
References: <4DD6D573.2060800@erley.org>
	 <1305925719.1444.11.camel@wwguy-ubuntu>  <4DD6DCCC.2080106@erley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 09:51:17 -0700
Message-ID: <1305996677.27147.1.camel@wwguy-ubuntu> (sfid-20110521_185443_588406_140AD494)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pat,

On Fri, 2011-05-20 at 14:27 -0700, Pat Erley wrote:
> On 05/20/2011 05:08 PM, wwguy wrote:
> > Hi Pat,
> > 
> > 
> > Just want to be clear, which message flooding your system?
> > is 
> > iwlagn 0000:03:00.0: Aggregation not enabled for tid
> >> 0 because load = 9
> 
> This I only see occasionally.
> 
> > or
> > iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:0c:42:64:bb:1d
> >> tid = 0
> 
> This message is the one that I've gotten over 1600 of in 16 hours.
> 
> >>
> > the second message should only show once when the aggregation being establish. if you are seeing it every 35 seconds, that is bad. 
> > but the first message is checking the traffic load is high enough to establish the aggregation queue, which is ok.
> > and we should not log this type of message as "ERROR", I will submit a patch to change that.
> > 
> 
> Feel free to include me in on the CC for that patch.  Will test.
> 
It is not the normal behavior you are seeing over 1600 aggregation
attempt in 16 hours.
Could you please help me to debug this with following debug flag

$sudo modprobe iwlagn debug=0x4100002

Thanks
Wey




