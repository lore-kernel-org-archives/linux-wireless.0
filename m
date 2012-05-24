Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38637 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2EXGgs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 02:36:48 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
	<87wr436utp.fsf@purkki.adurom.net>
	<CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
	<87mx4z6u4n.fsf@purkki.adurom.net>
	<CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
	<87ipfn6koz.fsf@purkki.adurom.net>
	<CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com>
	<87ehqa6u2d.fsf@purkki.adurom.net>
	<CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com>
Date: Thu, 24 May 2012 09:36:46 +0300
In-Reply-To: <CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com>
	(Arik Nemtsov's message of "Thu, 24 May 2012 08:32:14 +0300")
Message-ID: <87aa0y6q69.fsf@purkki.adurom.net> (sfid-20120524_083651_751109_85B355F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> On Thu, May 24, 2012 at 8:12 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> But this was a workaround for an IOP problem with certain APs, right?
>> How is firmware going to be smart in that case?
>>
>> It would help to see what you are exactly planning to do on wl12xx with
>> this interface. Currently I'm just guessing what your plans really are.
>
> The plan is to enable only VO as U-APSD (as I wrote in a previous
> email).

You mean you will hardcode it in wl12xx and with all APs only VO has
U-APSD enabled?

> We've had problems with some APs (can't remember the models) that
> assume non-VO ACs always use legacy PS. This would lead to problems -
> our driver would never wake up. In that sense the problem is general.

Yeah, that looks like a general problem but of course it's difficult to
make any conclusions with this little data.

-- 
Kalle Valo
