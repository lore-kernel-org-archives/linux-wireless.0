Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64783 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZILO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:11:14 -0500
Received: by mail-lb0-f175.google.com with SMTP id 10so6290677lbg.6
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 00:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87iofugh9w.fsf@kamboji.qca.qualcomm.com>
References: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
	<1422190968-14422-1-git-send-email-zajec5@gmail.com>
	<87iofugh9w.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 26 Jan 2015 09:11:12 +0100
Message-ID: <CACna6rxHxJNBaQ6coxu_NYw-_NZkC6gnBE_rrXZmdYQT0XSZeg@mail.gmail.com> (sfid-20150126_091120_170869_4049632B)
Subject: Re: [PATCH V2 1/2] bcma: add empty PCIe hostmode functions if support
 is disabled
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 January 2015 at 07:58, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> This allows us to drop some #ifdef magic (mess).
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: Return false in bcma_core_pci_is_in_hostmode
>>     Don't (accidentally) modify bcma_host_soc_register_driver
>
> It would be far more reliable if you resend the whole patchset instead
> of resending invidiviual patches within the set. Otherwise the chances
> are that I apply the wrong version.

Oops. I always take care of removing old versions from patchwork and
using --in-reply-to, I was hoping it's OK.

How would you like whole patches to be re-send? Should I resend them
independently? Or should every patch from the patchset include
In-Reply-To pointing to its previous version?

Is this just an advise for the future, or would you like me to resend
this patchset too?

-- 
Rafał
