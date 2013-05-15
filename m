Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38496 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab3EORd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 13:33:26 -0400
Message-ID: <5193C6DC.40709@candelatech.com> (sfid-20130515_193329_942170_4236C470)
Date: Wed, 15 May 2013 10:33:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Corey Richardson <corey@octayn.net>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc works poorly in 3.9
References: <CA++BO6SfpV_7pimE=-TUcbXRX9Xgd8v69B5AQzPQ2g1b82e0FA@mail.gmail.com> <5189E31F.2090200@rempel-privat.de> <CA++BO6TBrzJtD2cnNmUu4j6G2c5tSq228318avuGVF4r1NeW-A@mail.gmail.com>
In-Reply-To: <CA++BO6TBrzJtD2cnNmUu4j6G2c5tSq228318avuGVF4r1NeW-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2013 10:31 AM, Corey Richardson wrote:
> On Wed, May 8, 2013 at 1:31 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> If it is an regression, can you please do "git bisect". If you can locate
>> the patch which introduced this regression, it will be great.
>>
>
> It seems to have been an intermittent problem with my WAP as well; the
> PoE wasn't consistent so it kept dropping out, also taking down the
> adapter with it. It does seem to be a regression, but it's so hard to
> reproduce that I don't think it's worth pursuing.

Sometimes I see the NIC fail to boot up on reboot of the OS.
I've only tested 3.9 kernels with these NICs, as I haven't used
them previously.

The kernel message was something about not being able to upload
firmware to the adapter...I'll grab some logs next
time I see it.

Thanks,
Ben

>
> Thanks!
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

