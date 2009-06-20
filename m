Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:4012 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZFTFVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 01:21:34 -0400
Received: by an-out-0708.google.com with SMTP id d40so3584452and.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 22:21:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ws77o76m.fsf@litku.valot.fi>
References: <4A3C2036.6060506@gmail.com> <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
	<4A3C4593.6050707@gmail.com> <43e72e890906191915g2c9736f2i4633c8ed3766fe3b@mail.gmail.com>
	<4A3C4745.7000706@gmail.com> <43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com>
	<87ws77o76m.fsf@litku.valot.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Jun 2009 22:21:16 -0700
Message-ID: <43e72e890906192221p5cc67d28gb14b214bbf252ad@mail.gmail.com>
Subject: Re: iwl3945 not working after recent commits
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Darren Blaber <dmbtech@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 9:33 PM, Kalle Valo<kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>>> I'm using 2.6.30 with the KMS radeon patches, don't know if that is
>>> interfering. I'll try wireless-testing directly.
>>
>> Yeah this is odd, 2.6.30 shouldn't have an issue with backport unless
>> I'm missing something. Let us know how it goes with wireless-testing.
>
> I'm using latest wireles-testing and I have iwl3945 on my X60s. iwl3945
> is working fine for me.

Yeah the user tried a vanilla 2.6.30 and it seems to be working fine
now, it seems related to kms somehow.

  Luis
