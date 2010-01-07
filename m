Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:9305 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab0AGGvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 01:51:00 -0500
Received: by ey-out-2122.google.com with SMTP id 22so857946eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 22:50:58 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix a few work bugs
References: <1262788258.9268.113.camel@johannes.local>
	<87aawrusi8.fsf@purkki.valot.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 07 Jan 2010 08:50:56 +0200
In-Reply-To: <87aawrusi8.fsf@purkki.valot.fi> (Kalle Valo's message of "Wed\, 06 Jan 2010 18\:07\:11 +0200")
Message-ID: <87637ev25r.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> Kalle and Lennert reported problems with the new work
>> code, and at least Kalle's problem I was able to trace
>> to a missing jiffies initialisation.
>>
>> I also ran into a problem where occasionally I couldn't
>> connect, which seems fixed with kicking the work items
>> after scanning.

[...]

> Because I'm currently travelling, I have tested this only once. Will
> test more when I get back home.

I have now tested this by rebooting few times and I didn't notice any
problems. So the patch seems to really help.


-- 
Kalle Valo
