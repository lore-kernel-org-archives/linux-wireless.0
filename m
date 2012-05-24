Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53146 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2EXFMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 01:12:43 -0400
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
Date: Thu, 24 May 2012 08:12:42 +0300
In-Reply-To: <CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com>
	(Arik Nemtsov's message of "Wed, 23 May 2012 17:35:20 +0300")
Message-ID: <87ehqa6u2d.fsf@purkki.adurom.net> (sfid-20120524_071247_473320_A4B0D854)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> On Wed, May 23, 2012 at 5:22 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> We just enable the driver to override a default value, which is used
>>> by mac80211.
>>
>> You are moving logic from mac80211 to the driver but it should be the
>> opposite, the driver should be dumb and mac80211 should control
>> everything. Didn't we have a similar discussion last year when talking
>> about controlling dynamic power save?
>
> I disagree. Not all mac80211 drivers are like ath9k. The
> FW/lower-driver can be just as smart in certain areas (BA sessions for
> instance).

But this was a workaround for an IOP problem with certain APs, right?
How is firmware going to be smart in that case?

It would help to see what you are exactly planning to do on wl12xx with
this interface. Currently I'm just guessing what your plans really are.

> Also, let's stay practical here. This is not a large and complex
> feature like dynamic power save.

So when making small changes it's doesn't matter if the patch looks
wrong? That sounds like a bad idea. What do we when have 50 of those
small patches?

> It's interesting to hear Johannes' take on this.

I'm sure he will answer when he finds the time. But instead crying
Johannes for help you could address my concerns. You are basically
ignoring my comments right now.

-- 
Kalle Valo
