Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55345 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZLALrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:47:32 -0500
Received: by bwz27 with SMTP id 27so3335382bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 03:47:38 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: python nl80211 code
References: <87hbsb6pot.fsf@purkki.valot.fi>
	<1259659425.32171.54.camel@johannes.local>
	<87638r6l4i.fsf@purkki.valot.fi>
	<1259666699.32171.72.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 13:47:36 +0200
In-Reply-To: <1259666699.32171.72.camel@johannes.local> (Johannes Berg's message of "Tue\, 01 Dec 2009 12\:24\:59 +0100")
Message-ID: <87ws166hlz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> The parsing of nl80211 seems to fail. If I find some time, I try to
>> look at it.
>
> Oh, that's not surprising, it's over two years old and after I started
> writing the C tool (iw) I never maintained the comments in nl80211.h
> that this tried to parse.

Ok, good to know. What do you think if I remove the parsing of
nl80211.h and instead add the nl80211 commands manually as python
code? Sure, it's monkey code but easier to maintain IMHO.

Or have some intermediate language, maybe. Any ideas?

-- 
Kalle Valo
