Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:27632
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858Ab3CNNqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 09:46:07 -0400
Message-ID: <5141D499.3000207@posedge.com> (sfid-20130314_144611_878228_3A5DF8A2)
Date: Thu, 14 Mar 2013 19:16:01 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
References: <513DE4BB.9010104@posedge.com>  <1363012784.5284.5.camel@jlt4.sipsolutions.net>  <513DF675.3000800@posedge.com> <1363015558.5284.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363015558.5284.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 08:55 PM, Johannes Berg wrote:
> On Mon, 2013-03-11 at 20:51 +0530, Mahesh Palivela wrote:
>
>> I tested this patch. scan works.
> Works how? It never tells the driver to go to a different channel ...
>
> Besides, telling the driver to go to one channel via the hw_config call,
> and using chanctx for vif configuration seems like a really bad idea.
I think hw_config() should be modified to add vif param and call drivers?
can we proceed with that approach?

Thanks,
Mahesh
