Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:2224 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXI2QOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 12:14:10 -0400
Message-ID: <46FE792C.6000803@errno.com>
Date: Sat, 29 Sep 2007 09:11:24 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Li YanBo <dreamfly281@gmail.com>,
	Patrick Ziegler <patrick.ziegler@fh-kl.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: 802.11n drivers
References: <46FCF7E7.6080706@fh-kl.de>	 <1190991810.3907.7.camel@johannes.berg>	 <1197ff4c0709281909u25421b6ay60f5d059fa3e906a@mail.gmail.com> <1191055790.22960.39.camel@johannes.berg>
In-Reply-To: <1191055790.22960.39.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2007-09-29 at 10:09 +0800, Li YanBo wrote:
>
>   
>> The Airgo chipset is a pre-n product, and the feature to support
>> standard 802.11n hasn't been implement yet. we will try to see whether
>> it can be used to support 80211n later. but if anything I can help you
>> now, I'd glad to do.
>>     
>
> Oh, ok, do you know what's different between the pre-N implemented by
> this chip and standard-N (say draft 2.0 or so)?
>   

I am aware of 3 flavors: pre-N (pre 802.11 working group, like Airgo), 
D1.x 11n, D2.x 11n.  Getting D1.x and D2.x cards to interop isn't a big 
deal (at least at some reduced level of operation).  Several things make 
this confusing:

1. retail labeling is unclear
2. chips are being rev'd quickly so retail products are typically out of 
date
    before they hit the shelves
3. 11n isn't ratified so in the meantime various groups have defined 
test plans
    for interop and compliance w/ one plan doesn't necessarily mean you
    interop w/ the other(s)

Now is definitely the time to be doing 11n.  There is significant effort 
getting up to speed on all that is involved.

    Sam

