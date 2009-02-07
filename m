Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:39283 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZBGHmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 02:42:40 -0500
Received: by fg-out-1718.google.com with SMTP id 16so693489fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 23:42:38 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: Remove TSF atomic requirement from the documentation
References: <20090205165834.63840@gmx.net> <87fxirpe1q.fsf@litku.valot.fi>
	<1233953047.4175.27.camel@johannes.local>
	<87ocxfp937.fsf@litku.valot.fi>
	<1233954680.4175.36.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 07 Feb 2009 09:34:33 +0200
In-Reply-To: <1233954680.4175.36.camel@johannes.local> (Johannes Berg's message of "Fri\, 06 Feb 2009 22\:11\:20 +0100")
Message-ID: <87d4duitti.fsf@litku.valot.fi> (sfid-20090207_084245_887987_B4DAEF11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-02-06 at 23:08 +0200, Kalle Valo wrote:
>
>> Alina, it would be nice to explicitly mention that the function can
>> sleep. Otherwise driver authors need to guess if sleeping is allowed
>> or not.
>
> That's a larger project to actually annotate all of them either way ;) 

Yes, but we can start with smaller pieces ;)

> I think we only mention atomicity requirements right now.

I found only one spot:

 * @set_key: See the section "Hardware crypto acceleration"
 *	This callback can sleep, and is only called between add_interface

But, like you said, we can add these later.

-- 
Kalle Valo
