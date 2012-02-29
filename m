Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40853 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2B2Ig3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:36:29 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Occasional truncated scan results
References: <4F4CE4D6.6020108@raritan.com>
	<1330440166.3368.7.camel@jlt3.sipsolutions.net>
	<4F4CEFA6.2090005@raritan.com>
	<1330442659.3368.13.camel@jlt3.sipsolutions.net>
	<4F4CF454.8050207@raritan.com>
Date: Wed, 29 Feb 2012 10:36:27 +0200
In-Reply-To: <4F4CF454.8050207@raritan.com> (Ronald Wahl's message of "Tue, 28
	Feb 2012 16:35:48 +0100")
Message-ID: <87linmavec.fsf@purkki.adurom.net> (sfid-20120229_093633_268744_44BEBE5B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ronald Wahl <ronald.wahl@raritan.com> writes:

>> Ok. Yes, this could be fixed by making sure that a single BSS is
>> atomically written or not written -- probably simply by rolling back at
>> the end of the function if it didn't fit and returning an error etc. If
>> you wanted to work on this, I'd review&  accept the patch, but I have no
>> intention whatsoever to do this myself :-)
>
> I'll first check if I can use the nl80211 interface in all cases. If
> not I'll probably come up with a patch. Thanks!

Even if switching to nl80211 would require a lot of effort from you I
still strongly recommend switching. That will save you a lot of
time in the future and the investment will surely pay back. PHBs like
that :)

-- 
Kalle Valo
