Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48961 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZIMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:12:23 -0500
Received: by mail-lb0-f182.google.com with SMTP id l4so6267347lbv.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 00:12:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87egqiggzi.fsf@kamboji.qca.qualcomm.com>
References: <1422205297-24767-1-git-send-email-zajec5@gmail.com>
	<87egqiggzi.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 26 Jan 2015 09:12:20 +0100
Message-ID: <CACna6rx8LQZLPmAp8mgXro_5=ppprKHrRe7L-VFEU=Qdz60Edw@mail.gmail.com> (sfid-20150126_091225_484229_3BDD6251)
Subject: Re: [PATCH] b43: AC-PHY: prepare place for developing new PHY support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 January 2015 at 08:04, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> There are new (not anymore?) Broadcom 802.11ac wireless cards based on
>> chipsets like BCM4352 and BCM4360. They use a new PHY type (called
>> simply AC) that will require new specific code.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>
>> Kalle: as this commit & Kconfig say, this is just a beginning of new
>> PHY type support. In the past we used development model this patch
>> follows. Code for new PHY was added patch by patch. Adding everything
>> at once would require a huge patchset & development behing the doors.
>> Also sending small patches allows better review of changes & should
>> result in a better code quality. Let me know if there are any
>> problems.
>
> Sounds good to me. Just keep dependency to BROKEN until it's usable and
> make sure that the code compiles after every patch.

Alright! :)

-- 
Rafał
