Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52517 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbcAVLlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 06:41:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: ignore eeprom magic mismatch on flash based devices
References: <1453390448-87417-1-git-send-email-nbd@openwrt.org>
	<CAFBinCByH_HSMHNhQO93U+K21ssb5W_abzOVTp=XWqOcqAnL_w@mail.gmail.com>
Date: Fri, 22 Jan 2016 13:41:46 +0200
In-Reply-To: <CAFBinCByH_HSMHNhQO93U+K21ssb5W_abzOVTp=XWqOcqAnL_w@mail.gmail.com>
	(Martin Blumenstingl's message of "Thu, 21 Jan 2016 17:46:22 +0100")
Message-ID: <871t99yh6t.fsf@kamboji.qca.qualcomm.com> (sfid-20160122_124156_809706_01A716D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> On Thu, Jan 21, 2016 at 4:34 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Many AR913x based devices (maybe others too) do not have a valid EEPROM
>> magic in their calibration data partition.
>>
>> Fixes: 6fa658fd5ab2 ("ath9k: Simplify and fix eeprom endianness swapping")
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

I'll queue this to 4.5.

> I wonder if we should also backport this to 4.4, because that is
> affected as well.

Is it? I don't see 6fa658fd5ab2 in 4.4. Can you double check, please?

-- 
Kalle Valo
