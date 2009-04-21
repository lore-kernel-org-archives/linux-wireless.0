Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:52351 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUFYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 01:24:32 -0400
Received: by bwz7 with SMTP id 7so1567945bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 22:24:30 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 powersave work
References: <20090416111723.904720021@sipsolutions.net>
	<20090420194430.GG3369@tuxdriver.com>
	<1240257188.4632.19.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Apr 2009 08:24:28 +0300
In-Reply-To: <1240257188.4632.19.camel@johannes.local> (Johannes Berg's message of "Mon\, 20 Apr 2009 21\:53\:08 +0200")
Message-ID: <87ocuqfuk3.fsf@litku.valot.fi> (sfid-20090421_072440_347837_BAA6B1F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> I'm not sure I understand.  Your patch (which would go to 2.6.31)
>> has it turned-on by default.  Which way do you want it?
>
> I want it turned on by default, at least in wireless-testing; Kalle
> thinks that we should turn it off for a .31 release.
>
> I would think that since an easy workaround is available ("iwconfig
> wlan0 power off") and it doesn't affect most hardware yet anyway (only
> those supporting powersave) we should turn it on by default anyway,
> since otherwise we won't find any bugs -- but maybe that's just me.

Yes, in my opinion the power save should not be enabled by default for
the big masses, at least not yet. My understanding is that only few
people have tested it and I would like to see more testing first. 

But if you (Johannes&John) think it's ready for the prime time, I'm not
going to complain :)

-- 
Kalle Valo
