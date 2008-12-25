Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:64308 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYLYCfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 21:35:32 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3398738wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2008 18:35:31 -0800 (PST)
Message-ID: <1197ff4c0812241835u70bb55e3i713103946148c2f1@mail.gmail.com> (sfid-20081225_033633_345484_3233E24A)
Date: Thu, 25 Dec 2008 10:35:31 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Broadcom 11n implementation
Cc: bcm43xx-dev@lists.berlios.de,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200812250115.45283.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1230163530.3162.10.camel@johannes>
	 <200812250115.45283.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/25/08, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 25 December 2008 01:05:30 Johannes Berg wrote:
>> Hey,
>>
>> I hope those of you who got their presents today enjoyed that. Here's
>> one from me for the poor souls like myself who have a Broadcom 11n chip:
>>
>> I've been publishing specifications for things we have reverse
>> engineered, is anyone interested in implementing this? If so, go wild,
>> but synchronise on the list if there are multiple people. John, I think
>> you had somebody who was interested, but I can't find the email right
>> now.
>>
>> Michael has said that he might be able to help a bit (review maybe), but
>> won't implement the bulk of it. And I actually need this code ASAP since
>> I failed to replace the wireless card in my new MacBook (I couldn't even
>> find it).
>
> Of course, I will always be available to give advise and help on the
> technical details.
> With the recent merge of the PHY abstraction in b43 it shouldn't be that
> hard
> anymore to understand the basics of the code. I think stuff is clearly
> modulised now
> and fairly easy to understand, after you once understood the basics of the
> device.
>
> So for implementing N-PHY, you'll basically work inside of the phy_n.c and
> phy_n.h files only (maybe 98% of the work will be there).
>
> So, you could probably look into phy_g.c to get an idea of how this could
> probably
> look like.
>
> Please contact us before you start writing patches, so we can give some
> additional
> advise on coding conventions used in the driver.
>
Consider the currently AGNX project in logjam cause lack of some RF
specs detail,  I think I have some time to do this. or with other guys
who also interesting with it.

Merry Christmas to everybody! :)

BR
Yanbo
