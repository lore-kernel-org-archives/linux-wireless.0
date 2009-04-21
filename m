Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:35119 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZDUNJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 09:09:54 -0400
Received: by bwz7 with SMTP id 7so1749338bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 06:09:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 powersave work
References: <20090416111723.904720021@sipsolutions.net>
	<20090420194430.GG3369@tuxdriver.com>
	<1240257188.4632.19.camel@johannes.local>
	<87ocuqfuk3.fsf@litku.valot.fi> <20090421125132.GC17805@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Apr 2009 16:09:48 +0300
In-Reply-To: <20090421125132.GC17805@tuxdriver.com> (John W. Linville's message of "Tue\, 21 Apr 2009 08\:51\:32 -0400")
Message-ID: <87d4b6f90j.fsf@litku.valot.fi> (sfid-20090421_150958_387609_CE1D03B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

>> Yes, in my opinion the power save should not be enabled by default for
>> the big masses, at least not yet. My understanding is that only few
>> people have tested it and I would like to see more testing first. 
>> 
>> But if you (Johannes&John) think it's ready for the prime time, I'm not
>> going to complain :)
>
> Well there is always a trade-off.  But by the time 2.6.31 come around
> the code will have been in wireless-testing, net-next, and linux-next
> for a reasonably long time.  Hopefully we will have good confidence
> in it by then.  If not, then we can disable it by default later.

That sounds good. With those three trees there should be quite a lot of
testers.

-- 
Kalle Valo
