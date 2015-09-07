Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49445 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbIGNVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 09:21:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440968574-29490-2-git-send-email-Jes.Sorensen@redhat.com>
	<87twr7fvbb.fsf@kamboji.qca.qualcomm.com>
	<wrfjoahff1mg.fsf@redhat.com>
Date: Mon, 07 Sep 2015 16:20:58 +0300
In-Reply-To: <wrfjoahff1mg.fsf@redhat.com> (Jes Sorensen's message of "Sun, 06
	Sep 2015 21:40:23 -0400")
Message-ID: <87io7me56t.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_152115_362161_0EAD4B22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

>>> +static int rtl8xxxu_debug /* = 0 */; /* Avoid pointless checkpatch noise */
>>
>> Either assign it to zero or ignore the checkpatch warning, but please
>> don't do this.
>
> Problem is if I leave the = 0 some people will send pointless patches to
> change it. The above gets checkpatch to shut up while leaving the
> indication in place.

Yeah, I guessed that but this is just silly. If it annoys so much fix
the checkpatch script or really assign it to zero, not this kind of
comment trickery.

-- 
Kalle Valo
