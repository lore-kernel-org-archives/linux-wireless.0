Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35494 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3KFGfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 01:35:07 -0500
Received: from mail-pd0-f174.google.com (mail-pd0-f174.google.com [209.85.192.174])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 7C4288813E
	for <linux-wireless@vger.kernel.org>; Wed,  6 Nov 2013 14:35:06 +0800 (CST)
Received: by mail-pd0-f174.google.com with SMTP id z10so9785326pdj.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 22:35:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
References: <5276134B.8070808@wzyboy.org> <0BA3FCBA62E2DC44AF3030971E174FB301DE75AE@HASMSX103.ger.corp.intel.com>
 <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Wed, 6 Nov 2013 14:34:50 +0800
Message-ID: <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com> (sfid-20131106_073515_014415_7DAA00F4)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/6 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>>
>> Hi, I'm back.
>>
>> This terriable bug occurs again in Linux 3.12. This time I've been prepared for
>> it and wrote down the complete process of its apperance and my reacting, as
>> attached.
>
> Thanks - was that with power save disabled?

Yes, Linux 3.12 with "options iwlmvm power_scheme=1". (I did not touch
that .conf file after the kernel upgrade)

>
>>
>> IMHO they are quite similar with those errors in 3.11...
>
> Indeed. The only difference is that you don’t have PCI complain about not being able to disable L1.

I see. But I still cannot figure out what is the "trigger" of this
bug. Today (Nov 06 UTC+8) this bug occurs twice till now (14:30), they
were at 12:31 and 13:30. At the first time I was about to do a system
upgrade and at the second time I was using rsync to upload photos from
my Android phone to my laptop.

Sometimes I was not even using network (the traffic was near zero)
when the bug occurs. So this bug seems to occur no matter of network
traffic states?

Could you think of a possible "trigger" of this bug so I could try to
avoid it (I hate rebooting) before the final fix is released? For
example, if there is something wrong with the "modules linked in" I
could blacklist that module...


Sincere regards.

-- 
wzyboy
