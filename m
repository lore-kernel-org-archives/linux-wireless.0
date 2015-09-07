Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbbIGVIL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 17:08:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440968574-29490-2-git-send-email-Jes.Sorensen@redhat.com>
	<87twr7fvbb.fsf@kamboji.qca.qualcomm.com>
	<wrfjoahff1mg.fsf@redhat.com>
	<87io7me56t.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 07 Sep 2015 17:08:08 -0400
In-Reply-To: <87io7me56t.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 07 Sep 2015 16:20:58 +0300")
Message-ID: <wrfj8u8idjk7.fsf@redhat.com> (sfid-20150907_230820_576399_B138D608)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>>>> +static int rtl8xxxu_debug /* = 0 */; /* Avoid pointless checkpatch noise */
>>>
>>> Either assign it to zero or ignore the checkpatch warning, but please
>>> don't do this.
>>
>> Problem is if I leave the = 0 some people will send pointless patches to
>> change it. The above gets checkpatch to shut up while leaving the
>> indication in place.
>
> Yeah, I guessed that but this is just silly. If it annoys so much fix
> the checkpatch script or really assign it to zero, not this kind of
> comment trickery.

I'll remove it. The real problem here is that checkpatch has gotten to
the point where it is at times causing more harm than good. It is
unlikely to get fixed, get there is a small group who see it as their
mission to force their ways upon others, no matter whether it matters or
not.

Jes
