Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58073 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3A2VuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:50:19 -0500
Message-ID: <51084415.9060409@candelatech.com> (sfid-20130129_225023_074422_19B58056)
Date: Tue, 29 Jan 2013 13:50:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/agg-tx.c:625  (3.7.5)
References: <510842C4.3040608@candelatech.com>  (sfid-20130129_224440_836761_5DE244B3) <1359496013.8108.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359496013.8108.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 01:46 PM, Johannes Berg wrote:
> On Tue, 2013-01-29 at 13:44 -0800, Ben Greear wrote:
>> This is in 3.7.5, plus one ath9k patch to over-ride eeprom regdomain.
>>
>> Code that causes this is here...I seem to have a good test case for
>> this currently, so if there is any other debugging I could put here
>> that would be useful, let me know.
>>
>> 	if (WARN_ON(!tid_tx)) {
>> 		ht_dbg(sdata, "addBA was not requested!\n");
>> 		goto unlock;
>> 	}
>
> Heh, I think Kalle just had the same. Do you have the ht_dbg()
> statements (i.e. HT debugging) enabled?

No, it seems I do not.

Want me to enable it?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

