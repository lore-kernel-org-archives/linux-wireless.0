Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:41350 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779Ab2K0GU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:20:56 -0500
Message-ID: <50B45BC2.3070406@posedge.com> (sfid-20121127_072059_333995_A1EDD246)
Date: Tue, 27 Nov 2012 11:50:50 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: re-organize the rx rate calculation logic
References: <d4c0566bd33c1afdcc0f7b820024d19f@posedge.com> <1353942490.2800.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353942490.2800.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 08:38 PM, Johannes Berg wrote:
> Generally, this seems fine. Your patches are line-wrapped though.
>
I reviewed all the patches and unable to find the line-wrapped :(
Could you help me by pointing out which line is exactly getting wrapped?
So that i will figure out where exactly i am missing and will correct 
the same.
>> Signed-off-by: Saravana <saravanad@posedge.com>
>> ---
>> The diff file is generated from wireless-testing git tree.
>
> I just changed this code in mac80211-next and would appreciate if you
> would rebase onto that.
>
I am also facing the same problem in cloning the mac80211-next. once 
that is resolved, will use the mac80211-next as base and then send 
patches on top of that.
> That blank line is in the wrong spot, it should be after the closing
> bracket :)
>
will add the blank line after the closing bracket.
> johannes
>
>

