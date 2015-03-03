Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbCCN3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:29:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH next] bcma: add missing includes
References: <1425364377-12771-1-git-send-email-zajec5@gmail.com>
	<87ioei9t28.fsf@kamboji.qca.qualcomm.com>
	<CACna6ry0DFNr1fN-ZA_8AULQ5sJSzS3Gq+SKyn+FOnD+2KsZ3A@mail.gmail.com>
Date: Tue, 03 Mar 2015 15:28:58 +0200
In-Reply-To: <CACna6ry0DFNr1fN-ZA_8AULQ5sJSzS3Gq+SKyn+FOnD+2KsZ3A@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 3 Mar 2015
 14:18:09 +0100")
Message-ID: <871tl69plx.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_142909_946528_03845779)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> On 3 March 2015 at 13:14, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> Please, no empty commit logs. I don't (yet) require that with all
>> patches, but this definitely needs one. Is this ok:
>>
>> bcma: add missing includes
>>
>> kbuild found out that commit 804e27dee49e ("bcma: support bringing up
>> bus hosted on PCIe Gen 2") broke the build on m68k:
>>
>>    drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>>>> drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of function 'pcie_set_readrq' [-Werror\
>> =implicit-function-declaration]
>>      err = pcie_set_readrq(dev, pcie2->reqsize);
>>      ^
>>    cc1: some warnings being treated as errors
>>
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> You're right, I could to better :| Yes, your version looks OK.

Thanks, I applied with my modifications.

-- 
Kalle Valo
