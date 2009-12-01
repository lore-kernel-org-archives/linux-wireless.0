Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48261 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbZLALwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:52:41 -0500
Received: by bwz27 with SMTP id 27so3338838bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 03:52:46 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: python nl80211 code
References: <87hbsb6pot.fsf@purkki.valot.fi>
	<1259659425.32171.54.camel@johannes.local>
	<87638r6l4i.fsf@purkki.valot.fi>
	<1259666699.32171.72.camel@johannes.local>
	<87ws166hlz.fsf@purkki.valot.fi>
	<1259668202.32171.73.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 13:52:44 +0200
In-Reply-To: <1259668202.32171.73.camel@johannes.local> (Johannes Berg's message of "Tue\, 01 Dec 2009 12\:50\:02 +0100")
Message-ID: <87skbu6hdf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Ok, good to know. What do you think if I remove the parsing of
>> nl80211.h and instead add the nl80211 commands manually as python
>> code? Sure, it's monkey code but easier to maintain IMHO.
>
> Yeah, I agree.

Good. I'll do that then.

>> Or have some intermediate language, maybe. Any ideas?
>
> I guess we could use sparse to output introspection information for
> nl80211.h instead, but is it worth it?

Increases coolness factory but that's about it =)

-- 
Kalle Valo
