Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:51073 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbbAZMbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 07:31:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2 1/2] bcma: add empty PCIe hostmode functions if support is disabled
References: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
	<1422190968-14422-1-git-send-email-zajec5@gmail.com>
	<87iofugh9w.fsf@kamboji.qca.qualcomm.com>
	<CACna6rxHxJNBaQ6coxu_NYw-_NZkC6gnBE_rrXZmdYQT0XSZeg@mail.gmail.com>
Date: Mon, 26 Jan 2015 14:31:08 +0200
In-Reply-To: <CACna6rxHxJNBaQ6coxu_NYw-_NZkC6gnBE_rrXZmdYQT0XSZeg@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Mon, 26 Jan 2015
 09:11:12 +0100")
Message-ID: <87siexg1v7.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_133120_164340_91163543)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> On 26 January 2015 at 07:58, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> This allows us to drop some #ifdef magic (mess).
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>> V2: Return false in bcma_core_pci_is_in_hostmode
>>>     Don't (accidentally) modify bcma_host_soc_register_driver
>>
>> It would be far more reliable if you resend the whole patchset instead
>> of resending invidiviual patches within the set. Otherwise the chances
>> are that I apply the wrong version.
>
> Oops. I always take care of removing old versions from patchwork

Yeah, I noticed that. That's really helpful, thanks for that.

> and using --in-reply-to, I was hoping it's OK.

But still ordering is different which might introduce problems while I
apply them. And like in your case, when I have to take the patches from
email due to UTF-8 problems, it won't work at all.

> How would you like whole patches to be re-send? Should I resend them
> independently? Or should every patch from the patchset include
> In-Reply-To pointing to its previous version?

Let's say you have a ten patch patchset and you have to change something
in patch 3. I would prefer that you resend the whole patchset (all 10
patches) and each patch in the patchset has "v2". So the version is
actually version of the patchset, not of the individual patch.

I assumed this was standard practice everywhere in the kernel, but I
guess I was wrong.

> Is this just an advise for the future, or would you like me to resend
> this patchset too?

For the future.

-- 
Kalle Valo
