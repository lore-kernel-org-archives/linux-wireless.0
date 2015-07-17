Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:47108 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160AbbGQNWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:22:08 -0400
Message-ID: <55A9017E.3080703@neratec.com> (sfid-20150717_152220_842805_9A40C5D3)
Date: Fri, 17 Jul 2015 15:22:06 +0200
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] cfg80211: Handle minimum bandwidth for quarter and
 half rates
References: <1434035553-6621-1-git-send-email-matthias.may@neratec.com>		 (sfid-20150611_171301_187773_8C09D939) <1437136527.1933.9.camel@sipsolutions.net>	 <55A8FF32.5070308@neratec.com> <1437138995.1933.13.camel@sipsolutions.net>
In-Reply-To: <1437138995.1933.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/15 15:16, Johannes Berg wrote:
> On Fri, 2015-07-17 at 15:12 +0200, Matthias May wrote:
>> I've improved this patch a bit since i posted v3.
>> Mainly setting more disabled flags when using a country code which
>> only
>> allows only narrow channels.
>> In certain circumstance it was possible to start operation on a 20/10
>>
>> channel on a channel which only allowed 5/10.
>>
>> I didn't post it yet because i was running some more tests with it
>> and
>> used it "productively" to see if something else breaks.
>> Will post it now.
>>
> Are you saying I should drop this version before I push it out?
>
> johannes
Yes please drop it.
