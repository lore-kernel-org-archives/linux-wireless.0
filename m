Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47683 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0IOHhA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:37:00 -0400
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
	<871v8v5vd2.fsf@purkki.adurom.net>
	<AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 15 Sep 2010 10:36:58 +0300
In-Reply-To: <AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com> (Jonathan Guerin's message of "Wed\, 15 Sep 2010 17\:27\:01 +1000")
Message-ID: <87wrqn4fvp.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonathan Guerin <jonathan@guerin.id.au> writes:

> So, we would prefer to match the spec for an out-of-the-box build,
> even tho it would appear to be a worse-performing driving to users?

If "an out-of-the-box build" means correctly working 802.11 device
then my opinion is yes, we should strive to match the spec even if the
performance decreases. Getting performance increases by violating the
spec is just stealing airtime from others.

But the challange is how to know if another 802.11 device is properly
working and following the spec? I know that Wi-Fi Alliance
certification tests contain lots of throughput tests to test for
contending the medium. So, for example, can we trust a device which
has passed Wi-Fi certification? I don't know.

-- 
Kalle Valo
