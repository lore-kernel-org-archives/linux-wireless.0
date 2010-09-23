Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:47422 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0IWSHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 14:07:10 -0400
Received: by pxi10 with SMTP id 10so543084pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 11:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285254226.3770.171.camel@jlt3.sipsolutions.net>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
 <20100923002240.GA4484@tux> <1285231958.3691.10.camel@jlt3.sipsolutions.net>
 <AANLkTikh+Q0AK+RyouLOQ5RN5wnKaD2TMnHR-ofqrMKJ@mail.gmail.com>
 <1285254157.3770.169.camel@jlt3.sipsolutions.net> <1285254226.3770.171.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 23 Sep 2010 11:06:49 -0700
Message-ID: <AANLkTimTQ1KP1JDBtSbxiMg-qvSm-Uw7H9EjDyp-WnrJ@mail.gmail.com>
Subject: Re: [PATCH] wifi-test: add simple roam test script
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"jiajia.zheng@intel.com" <jiajia.zheng@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 8:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-09-23 at 17:02 +0200, Johannes Berg wrote:
>> On Thu, 2010-09-23 at 07:53 -0700, Luis R. Rodriguez wrote:
>>
>> > >> After roaming for a good while, this is what I got, not sure
>> > >> yet what caused the NULL pointer dereference... Am I the only
>> > >> one able to reproduce this?
>> > >
>> > >> [ 3276.730081] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
>> > >> [ 3276.730148] IP: [<0000000000000003>] 0x3
>> > >
>> > > Something called a NULL pointer function pointer. Rafael recently said
>> > > "cpuidle is buggy" when a similar issue came up:
>> > > http://mid.gmane.org/201009182344.12498.rjw@sisk.pl
>> >
>> > But that seems related to ACPI, no? On my box I never suspended, I
>> > just associated and disassociated rapidly between two peers. The only
>> > suspicion I have is its obviously right after adding the STA peer.
>>
>> Yes, but he said suspend/resume _fixed_ it :-)
>
> Hm never mind, misunderstood the original report ... suspend + wait +
> resume was what was broken.
>
> But still, it's a NULL pointer call, and I can't really see how that
> would happen.

Hey so how do we know its a function ?

  Luis
