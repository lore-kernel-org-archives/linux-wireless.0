Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48566 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2H2PAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 11:00:24 -0400
Message-ID: <503E2E66.8010909@candelatech.com> (sfid-20120829_170027_983876_3FDF2E73)
Date: Wed, 29 Aug 2012 07:59:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Does ath9k support beam forming?
References: <503D14FF.5000309@candelatech.com> <CAD2nsn2JFEAwB0AauFiEYxj=mC7dNjFZn12EQ0q-aOwXjfZj4A@mail.gmail.com>
In-Reply-To: <CAD2nsn2JFEAwB0AauFiEYxj=mC7dNjFZn12EQ0q-aOwXjfZj4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2012 10:05 PM, Mohammed Shafi wrote:
> Hi Ben,
>
> On Wed, Aug 29, 2012 at 12:29 AM, Ben Greear <greearb@candelatech.com> wrote:
>> I saw some RFC patches about beam-forming from 2010, but grepping current
>> code doesn't find anything that indicates these patches ever made it
>> upstream.
>> Of course, I could be looking for the wrong thing...
>
> i think even though the patches are ready for submission,
> I think the testing them proved to be very challenging, where there
> does not seems to be consistent improvement(if not decrease)
> in throughput.  I can be wrong.
>
>>
>> Does the current ath9k code support beam-forming?
>
> no. hopefully we can support them(yet we need some considerable
> amount of time to test  i suppose).

Can you post the latest patch series for this?

And maybe we can make the functionality configurable by debugfs
so that we can test it out easily?

Are there any particular test cases that would help verify the
patches?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


