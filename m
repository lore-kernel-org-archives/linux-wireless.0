Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40613 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbCCNSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:18:10 -0500
Received: by iebtr6 with SMTP id tr6so57624777ieb.7
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 05:18:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ioei9t28.fsf@kamboji.qca.qualcomm.com>
References: <1425364377-12771-1-git-send-email-zajec5@gmail.com>
	<87ioei9t28.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 3 Mar 2015 14:18:09 +0100
Message-ID: <CACna6ry0DFNr1fN-ZA_8AULQ5sJSzS3Gq+SKyn+FOnD+2KsZ3A@mail.gmail.com> (sfid-20150303_141815_171059_90359B9D)
Subject: Re: [PATCH next] bcma: add missing includes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 March 2015 at 13:14, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Please, no empty commit logs. I don't (yet) require that with all
> patches, but this definitely needs one. Is this ok:
>
> bcma: add missing includes
>
> kbuild found out that commit 804e27dee49e ("bcma: support bringing up
> bus hosted on PCIe Gen 2") broke the build on m68k:
>
>    drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>>> drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of function 'pcie_set_readrq' [-Werror\
> =implicit-function-declaration]
>      err = pcie_set_readrq(dev, pcie2->reqsize);
>      ^
>    cc1: some warnings being treated as errors
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

You're right, I could to better :| Yes, your version looks OK.

-- 
Rafał
