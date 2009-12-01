Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37927 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZLAKbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 05:31:42 -0500
Received: by bwz27 with SMTP id 27so3285462bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 02:31:44 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: python nl80211 code
References: <87hbsb6pot.fsf@purkki.valot.fi>
	<1259659425.32171.54.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 12:31:41 +0200
In-Reply-To: <1259659425.32171.54.camel@johannes.local> (Johannes Berg's message of "Tue\, 01 Dec 2009 10\:23\:45 +0100")
Message-ID: <87638r6l4i.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2009-12-01 at 10:53 +0200, Kalle Valo wrote:
>> Hello,
>> 
>> I want to run some tests through nl80211 and, as usual, I prefer to
>> use python for that. Are there any scripts/examples using nl80211 with
>> python available? Preferably with an open enough license.
>
> http://git.sipsolutions.net/pynl80211.git/

Thanks. This looks interesting but doesn't compile right now:

$ make
Checking netlink numbers:
check.r5cOZHc/check.c: In function 'main':
check.r5cOZHc/check.c:63: error: lvalue required as left operand of
assignment
check.r5cOZHc/check.c:78: error: 'NL80211_CHAN_MAX' undeclared (first
use in this function)
check.r5cOZHc/check.c:78: error: (Each undeclared identifier is
reported only once
check.r5cOZHc/check.c:78: error: for each function it appears in.)
check.r5cOZHc/check.c:80: error: lvalue required as left operand of
assignment
check.r5cOZHc/check.c:86: error: 'NL80211_RATE_MAX' undeclared (first
use in this function)
[...]

The parsing of nl80211 seems to fail. If I find some time, I try to
look at it.

> Doesn't have much of a license but was intended to be GPLv2, but there
> was only one commit from somebody other than me who'd probably relicense
> if needed.

That's good enough :)

-- 
Kalle Valo
