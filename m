Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54687 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbcCRRlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 13:41:00 -0400
Message-ID: <56EC3DA6.2090105@osg.samsung.com> (sfid-20160318_184140_115082_F9180C79)
Date: Fri, 18 Mar 2016 17:40:54 +0000
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: johannes@sipsolutions.net, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix order of flag descriptions
References: <1458317369-28185-1-git-send-email-luisbg@osg.samsung.com> <1458318955-32070-1-git-send-email-luisbg@osg.samsung.com> <1458322179.26915.2.camel@perches.com>
In-Reply-To: <1458322179.26915.2.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/03/16 17:29, Joe Perches wrote:
> On Fri, 2016-03-18 at 16:35 +0000, Luis de Bethencourt wrote:
>> Fix order of mac80211_rx_flags description to match the enum.
>>
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>> ---
>> Hi,
>>
>> I want ahead and fixed the order of the descriptions. checkpatch.pl was giving
>> a warning to my previous patch and I had a hunch it was because the wrong order
>> breaks the parser. Indeed it does and with this patch below checkpatch.pl does
>> not complain about this flag descriptions anymore.
> 
> checkpatch complains?  About what?
> 

warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'

Is the warning checkpatch.pl gives against my first patch (add doc for
RX_FLAG_DUP_VALIDATED flag). This is silenced by reordering the descriptions to match
the order in the enum.

Thanks,
Luis
