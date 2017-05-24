Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966147AbdEXErG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 00:47:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-firmware@kernel.org
Subject: Re: [PATCH] linux-firmware: add wil6210 firmware 4.1.0.55
References: <1495370937-5369-1-git-send-email-qca_merez@qca.qualcomm.com>
        <20170523215351.GX13400@bombadil.infradead.org>
Date: Wed, 24 May 2017 07:47:01 +0300
In-Reply-To: <20170523215351.GX13400@bombadil.infradead.org> (Kyle McMartin's
        message of "Tue, 23 May 2017 14:53:51 -0700")
Message-ID: <87mva250ai.fsf@purkki.adurom.net> (sfid-20170524_064808_108489_C98ED962)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kyle McMartin <kyle@infradead.org> writes:

> On Sun, May 21, 2017 at 03:48:57PM +0300, Maya Erez wrote:
>> This is the latest firmware from wil6210 4.1 firmware branch.
>> 
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>> ---
>>  WHENCE      |  10 ++++++++++
>>  wil6210.brd | Bin 0 -> 3588 bytes
>>  wil6210.fw  | Bin 0 -> 350748 bytes
>>  3 files changed, 10 insertions(+)
>>  create mode 100644 wil6210.brd
>>  create mode 100644 wil6210.fw
>
> Sigh, I wish this was under a subdirectory, but since the kernel driver
> is already upstream, I guess we're SOL.

Yeah, I wish so too. We could always change the driver to use a
subdirectory but still we would have to keep these files without the
subdirectory in linux-firmware as the fallback for older kernels.

But I'll (try) make sure that all new wireless drivers will use a
subdirectory with firmware files.

-- 
Kalle Valo
