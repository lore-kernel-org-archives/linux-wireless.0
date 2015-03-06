Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41715 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbCFQYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 11:24:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, zajec5@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: randconfig build error with next-20150303, in drivers/bcma/driver_pcie2.c
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	<87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
	<20150305080130.41b132ee@canb.auug.org.au>
	<87sidj4kyv.fsf@kamboji.qca.qualcomm.com>
	<CA+r1Zhj+OnSsPzHy6mLRBU5QDYVeVFCwaKtvHWkfSy2hoL6=0w@mail.gmail.com>
Date: Fri, 06 Mar 2015 18:24:07 +0200
In-Reply-To: <CA+r1Zhj+OnSsPzHy6mLRBU5QDYVeVFCwaKtvHWkfSy2hoL6=0w@mail.gmail.com>
	(Jim Davis's message of "Thu, 5 Mar 2015 10:06:16 -0700")
Message-ID: <87d24m2ixk.fsf@kamboji.qca.qualcomm.com> (sfid-20150306_172432_486811_43846A71)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jim Davis <jim.epost@gmail.com> writes:

>>> However, that commit is in next-20150304 and we still get the error
>>> (see, for example,
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/12376688/).
>>
>> I applied few fixes from Rafal and Chen:
>>
>> 1ca2760fb2c1 bcma: prepare Kconfig symbol for PCI driver
>> 0a4e699a41f7 bcma: move internal function declarations to private header
>> c32ec2a11321 bcma: make bcma_host_pci_(up|down) calls safe for every config
>> b09f5ec18b16 bcma: Kconfig: Let it depend on PCI
>>
>> It would be great if someone could report if the build errors are gone
>> now.
>
> I reran that configuration file on
> wireless-drivers-next-for-davem-2015-02-07-9274-g1ca2760fb2c13, with
> no build errors.

Good, thanks for checking.

-- 
Kalle Valo
