Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0IOKBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 06:01:12 -0400
Received: by wwd20 with SMTP id 20so19566wwd.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 03:01:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wrqn4fvp.fsf@purkki.adurom.net>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
 <201009151216.32430.br1@einfach.org> <AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
 <201009151245.53194.br1@einfach.org> <AANLkTimHDXpazQ_rEXw81cdHLRmUpAA+r_tHGdvGOVYW@mail.gmail.com>
 <871v8v5vd2.fsf@purkki.adurom.net> <AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com>
 <87wrqn4fvp.fsf@purkki.adurom.net>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 20:00:51 +1000
Message-ID: <AANLkTi=ch5PozRHokWMgQPi71=gLPAaBYHR2eF6usadS@mail.gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
To: Kalle Valo <kvalo@adurom.com>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any chance we can 'acquire' those test plans? ;-)
--
Jonathan Guerin



On Wed, Sep 15, 2010 at 5:36 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Jonathan Guerin <jonathan@guerin.id.au> writes:
>
>> So, we would prefer to match the spec for an out-of-the-box build,
>> even tho it would appear to be a worse-performing driving to users?
>
> If "an out-of-the-box build" means correctly working 802.11 device
> then my opinion is yes, we should strive to match the spec even if the
> performance decreases. Getting performance increases by violating the
> spec is just stealing airtime from others.
>
> But the challange is how to know if another 802.11 device is properly
> working and following the spec? I know that Wi-Fi Alliance
> certification tests contain lots of throughput tests to test for
> contending the medium. So, for example, can we trust a device which
> has passed Wi-Fi certification? I don't know.
>
> --
> Kalle Valo
>
