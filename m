Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37887 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZA1Qq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:46:26 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] mac80211: ps-poll implementation
References: <20090122114240.31443.18218.stgit@tikku>
	<1232629209.4224.2.camel@johannes.local> <87prie8j30.fsf@nokia.com>
	<1232748717.3977.8.camel@johannes.local>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 28 Jan 2009 18:40:22 +0200
In-Reply-To: <1232748717.3977.8.camel@johannes.local> (ext Johannes Berg's message of "Fri\, 23 Jan 2009 23\:11\:57 +0100")
Message-ID: <87ljsvgz9l.fsf@nokia.com> (sfid-20090128_174631_195974_1F0EDC57)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-01-23 at 11:31 +0200, Kalle Valo wrote:
>
>> Ok. The problem is that stlc45xx/p54spi requires us to send a null
>> frame every time we enable power save and that's causing problems, at
>> least that's my current theory. So I need to solve this somehow, I
>> need to think this more.
>
> True.
>
>> But can we still apply these patches? Because b43 doesn't support
>> power save at all, and ath9k with dynamic power save disabled was
>> already broken before my patches, I consider these patches as a step
>> forward. And I would like to go forward one small step at a time,
>> maintaining huge patches myself until all issues are fixed is quite
>> difficult.
>
> Yes, agree, can you repost without RFC and the printk removed (and
> possibly rebased)?

Sure thing. I'm rebasing it right now.

-- 
Kalle Valo
