Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:48302 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbbAWTQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:16:58 -0500
Received: by mail-la0-f50.google.com with SMTP id hs14so2659953lab.9
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 11:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87h9vhl743.fsf@kamboji.qca.qualcomm.com>
References: <1421435929-21499-1-git-send-email-zajec5@gmail.com>
	<1421438379-26211-1-git-send-email-zajec5@gmail.com>
	<87h9vhl743.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 Jan 2015 20:16:56 +0100
Message-ID: <CACna6ryPpezpP2YUAC02omReuMHagAT2G9rEwh_NYpaOQK8uJA@mail.gmail.com> (sfid-20150123_201710_475466_DC1DC3DE)
Subject: Re: [PATCH V2] bcma: clean bus initialization code
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 January 2015 at 18:49, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> This moves main bus init code to the main.c and renames old function to
>> make its purpose clear.
>> Thanks to this change we'll also be able to separate scanning from
>> registration (and support PCIe Gen 2 devices) in the future.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: Fix typo (s/initialiation/initialization/)
>>     Put bcma_detect_chip earlier in .h to match order in .c
>
> Thanks, applied to wireless-drivers-next.git. But to avoid any UTF-8
> problems I applied this one manually from email. 'git log' and gitk look
> good to me, but please do check still that the log is valid.

Looks great, thanks.

I hope kernel.org team will upgrade patchwork soon so I can send more patches :|

-- 
Rafał
