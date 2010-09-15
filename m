Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54946 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0IOHRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:17:17 -0400
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
	<201009151216.32430.br1@einfach.org>
	<AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
	<201009151245.53194.br1@einfach.org>
	<AANLkTimHDXpazQ_rEXw81cdHLRmUpAA+r_tHGdvGOVYW@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 15 Sep 2010 10:17:13 +0300
In-Reply-To: <AANLkTimHDXpazQ_rEXw81cdHLRmUpAA+r_tHGdvGOVYW@mail.gmail.com> (Jonathan Guerin's message of "Wed\, 15 Sep 2010 14\:11\:39 +1000")
Message-ID: <871v8v5vd2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonathan Guerin <jonathan@guerin.id.au> writes:

>> the thing is, like bob said, that we don't really know much about what the HW
>> expects in some of these registers, so unless you can prove your changes to be
>> correct - e.g. by measurements which fit the theoretical model better, or by
>> better thruput, it's hard to say if they are correct or not.
>>
>> so before you worry about how to make a correct patch, just go ahead and
>> change those initvals to what you believe they should be. if it improves
>> something, let's talk about how to correctly fix it.
>
> I don't mean to be a smart-ass, but wouldn't setting the correct
> values here decrease the throughput? I'm not quite sure how to verify
> an improvement, other than get the card to contend for the medium with
> another known-working card? Does this sound reasonable?

Yes, it does sound reasonable. You might get throughput increase by
violating the spec.

-- 
Kalle Valo
