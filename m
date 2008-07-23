Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:64542 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGWPCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 11:02:12 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1047500ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 08:02:11 -0700 (PDT)
Message-ID: <1ba2fa240807230802q97dcc35rf1ecc2d8f40f6f8b@mail.gmail.com> (sfid-20080723_170215_519831_AA7D32CE)
Date: Wed, 23 Jul 2008 18:02:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information Element
Cc: "David Miller" <davem@davemloft.net>, johannes@sipsolutions.net,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, assaf.krauss@intel.com
In-Reply-To: <43e72e890807230615n1923b507me579c6a0be9929d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com>
	 <1213906688.8967.112.camel@johannes.berg>
	 <1ba2fa240806191329w7aef4ccaq587915d41d999edd@mail.gmail.com>
	 <20080619.150448.24028711.davem@davemloft.net>
	 <1ba2fa240806191532uf762d8avddfbe24aab05caf4@mail.gmail.com>
	 <43e72e890807230615n1923b507me579c6a0be9929d7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 4:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Jun 19, 2008 at 3:32 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Fri, Jun 20, 2008 at 1:04 AM, David Miller <davem@davemloft.net> wrote:
>>> From: "Tomas Winkler" <tomasw@gmail.com>
>>> Date: Thu, 19 Jun 2008 23:29:55 +0300
>>>
>>>> On Thu, Jun 19, 2008 at 11:18 PM, Johannes Berg
>>>> <johannes@sipsolutions.net> wrote:
>>>> >
>>>> >> >> +     if (country_ie_len < 6) {
>>>> >> >> +             printk(KERN_ERR "%s: country information element shorter (%d)"
>>>> >> >> +                     " than expected.\n", __func__, country_ie_len);
>>>> >> >
>>>> >> > Remotely exploitable security bug.
>>>> >
>>>> >> Please explain,
>>>> >
>>>> > Sending broken frames will fill the disk.
>>>>
>>>> I see thanks (yeah, distors doesn't make separate log partitions as default)
>>>
>>> How distros do their partitioning is neither here not there.  And even
>>> if they make a seperate log partition, that means it's still exploitable
>>> in that you will no longer get the other non-spam log messages that might
>>> be important to know about.
>>>
>>> Any kernel log message triggerable remotely without any kind of rate
>>> limiting is a bug.
>>
>> Will keep in mind
>
> Hey Tomas,
>
> Just wondering if you have some second version of these patches we can review?
Not yet I got back into this next week.
Thanks
Tomas
