Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62341 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2FSOcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:32:25 -0400
Message-ID: <4FE08D6F.30105@tieto.com> (sfid-20120619_163229_434563_4E35D538)
Date: Tue, 19 Jun 2012 16:32:15 +0200
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/5] bind filters and multicast list to subif
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com> <1340019946.4615.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340019946.4615.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2012 01:45 PM, Johannes Berg wrote:
> On Mon, 2012-06-18 at 12:57 +0200, Lukasz Kucharczyk wrote:
>> Hi,
>>
>> Following patches enables configuring filters and multicast list for
>> specific interface. That probably might be useful in implementation
>> of multi-channel operation.
>
> "Might be useful"?
>
> I guess I can see that, but we need
>   a) driver updates
>   b) to keep a global filter setting for drivers that don't have
>      per-interface settings
>

Ok, so I will need indication from driver what it supports.
Do you think adding single flag to ieee80211_hw_flags (like 
IEEE80211_HW_SUPPORTS_IFCE_FILTERS) would be sufficient for that purpose?

Lukasz


