Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39021 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbCDVmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 16:42:38 -0500
MIME-Version: 1.0
In-Reply-To: <20150305080130.41b132ee@canb.auug.org.au>
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	<87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
	<20150305080130.41b132ee@canb.auug.org.au>
Date: Wed, 4 Mar 2015 22:42:37 +0100
Message-ID: <CACna6rzDhYVhem=mNtjM=Wx0OHQGSZJCs6r969jBSGbQf6fsww@mail.gmail.com> (sfid-20150304_224254_877362_4FB62CCF)
Subject: Re: randconfig build error with next-20150303, in drivers/bcma/driver_pcie2.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kalle Valo <kvalo@codeaurora.org>, Jim Davis <jim.epost@gmail.com>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2015 at 22:01, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Kalle,
>
> On Wed, 04 Mar 2015 16:31:00 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Jim Davis <jim.epost@gmail.com> writes:
>>
>> > Building with the attached random configuration file,
>> >
>> > drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>> > drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of
>> > function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>> >   err = pcie_set_readrq(dev, pcie2->reqsize);
>> >   ^
>>
>> This should fix it:
>>
>> bcma: add missing includes
>>
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2264fc857decd45798368f46861d9aecac23546f
>
> However, that commit is in next-20150304 and we still get the error
> (see, for example,
> http://kisskb.ellerman.id.au/kisskb/buildresult/12376688/).

We're working on this, see
http://marc.info/?t=142541740600001&r=1&w=2

Sorry for the problem.

-- 
Rafał
