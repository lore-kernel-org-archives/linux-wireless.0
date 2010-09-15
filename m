Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34079 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0IOH1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:27:22 -0400
Received: by wwd20 with SMTP id 20so808204wwd.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 00:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871v8v5vd2.fsf@purkki.adurom.net>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
 <201009151216.32430.br1@einfach.org> <AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
 <201009151245.53194.br1@einfach.org> <AANLkTimHDXpazQ_rEXw81cdHLRmUpAA+r_tHGdvGOVYW@mail.gmail.com>
 <871v8v5vd2.fsf@purkki.adurom.net>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 17:27:01 +1000
Message-ID: <AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
To: Kalle Valo <kvalo@adurom.com>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, we would prefer to match the spec for an out-of-the-box build,
even tho it would appear to be a worse-performing driving to users?

--
Jonathan Guerin



On Wed, Sep 15, 2010 at 5:17 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Jonathan Guerin <jonathan@guerin.id.au> writes:
>
>>> the thing is, like bob said, that we don't really know much about what the HW
>>> expects in some of these registers, so unless you can prove your changes to be
>>> correct - e.g. by measurements which fit the theoretical model better, or by
>>> better thruput, it's hard to say if they are correct or not.
>>>
>>> so before you worry about how to make a correct patch, just go ahead and
>>> change those initvals to what you believe they should be. if it improves
>>> something, let's talk about how to correctly fix it.
>>
>> I don't mean to be a smart-ass, but wouldn't setting the correct
>> values here decrease the throughput? I'm not quite sure how to verify
>> an improvement, other than get the card to contend for the medium with
>> another known-working card? Does this sound reasonable?
>
> Yes, it does sound reasonable. You might get throughput increase by
> violating the spec.
>
> --
> Kalle Valo
>
