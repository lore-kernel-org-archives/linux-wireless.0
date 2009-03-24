Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:28813 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZCXWFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 18:05:18 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2764370yxl.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 15:05:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237926664.4320.131.camel@johannes.local>
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	<20090324184100.GA29268@tesla> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
	<43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
	<1237926664.4320.131.camel@johannes.local>
Date: Tue, 24 Mar 2009 15:04:59 -0700
Message-ID: <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com> (sfid-20090324_230522_487413_5B41CE1D)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 1:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-03-24 at 13:10 -0700, Luis R. Rodriguez wrote:
>
>> > Channel list is a good hint, maybe
>> > it's time to fix iw/nl80211 to send back all the channels :)
>>
>> So that is the other option. I tried looking at that yesterday but
>> wasn't able to find a way to do this. I went through the netlink
>> documenation and even tried modifying the skb on the kernel side as
>> its a dump. Not sure what to do here to fix this.
>
> I looked into yesterday actually, and it's completely non-trivial and
> requires userspace interface changes.

Heh, there goes that idea then. Then in that case I'd advocate even
more trimming the channels down.

  Luis
