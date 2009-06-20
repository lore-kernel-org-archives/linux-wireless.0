Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:11745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZFTEdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 00:33:37 -0400
Received: by fg-out-1718.google.com with SMTP id 16so699017fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 21:33:39 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Darren Blaber <dmbtech@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 not working after recent commits
References: <4A3C2036.6060506@gmail.com>
	<43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
	<4A3C4593.6050707@gmail.com>
	<43e72e890906191915g2c9736f2i4633c8ed3766fe3b@mail.gmail.com>
	<4A3C4745.7000706@gmail.com>
	<43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 20 Jun 2009 07:33:37 +0300
In-Reply-To: <43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com> (Luis R. Rodriguez's message of "Fri\, 19 Jun 2009 19\:24\:33 -0700")
Message-ID: <87ws77o76m.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> I'm using 2.6.30 with the KMS radeon patches, don't know if that is
>> interfering. I'll try wireless-testing directly.
>
> Yeah this is odd, 2.6.30 shouldn't have an issue with backport unless
> I'm missing something. Let us know how it goes with wireless-testing.

I'm using latest wireles-testing and I have iwl3945 on my X60s. iwl3945
is working fine for me.

-- 
Kalle Valo
