Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33874 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3FSREd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 13:04:33 -0400
Message-ID: <51C1E49C.1070802@candelatech.com> (sfid-20130619_190436_128496_919F6A7A)
Date: Wed, 19 Jun 2013 10:04:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: fix attrbuf access race by allocating a separate
 one
References: <CA+55aFxOde8n0M2=77-TQ2Ea9iz8s-e8zGFwjj6RVyMFXBgxEA@mail.gmail.com>   <20130618.190632.33329016434510583.davem@davemloft.net>   <CA+55aFz=eG5-zh1toHxrx=4Qm4DvwyiBCU3u-6tc0-utfZ6xiA@mail.gmail.com>   (sfid-20130619_042459_700600_08CD35A3) <1371628488.8349.3.camel@jlt4.sipsolutions.net>   (sfid-20130619_095509_334897_6BA231FA) <1371630238.8349.6.camel@jlt4.sipsolutions.net>  <51C1E2FF.3030309@candelatech.com> <1371661217.8349.26.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371661217.8349.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 10:00 AM, Johannes Berg wrote:
> On Wed, 2013-06-19 at 09:57 -0700, Ben Greear wrote:
>> On 06/19/2013 01:23 AM, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Since my commit 3713b4e364, nl80211_dump_wiphy() uses the global
>
>> The commit mentioned above (3713b4e364) is in 3.9.6,
>
> It isn't according to my git. :-)

Ahh, I was thinking that if 'git show foo' showed it, it was in that branch,
but I suppose that is not actually the case.

Sorry about that.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

