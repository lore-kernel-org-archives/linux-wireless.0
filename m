Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39600 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbGWQCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 12:02:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
	<55AD2C8F.9010509@broadcom.com>
Date: Thu, 23 Jul 2015 19:02:15 +0300
In-Reply-To: <55AD2C8F.9010509@broadcom.com> (Arend van Spriel's message of
	"Mon, 20 Jul 2015 19:14:55 +0200")
Message-ID: <87bnf2hng8.fsf@kamboji.qca.qualcomm.com> (sfid-20150723_180224_538173_5B1ED17F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>> This series comprises of following changes:
>>> - support NVRAM loading for bcm47xx platform.
>>> - revise announced interface combinations and validate against it.
>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>> - couple of PCIe fixes.
>>> - rework dealing with interface instances.
>>
>> I'm not sure which patch has caused this (I applied all of them except
>> for the 1st one) but now brcmfmac fails totally:
>>> Unable to handle kernel NULL pointer dereference at virtual address 00000014
>>
>> I'm afraid I won't be able to spend any more time of this soon, so can
>> you try to reproduce this problem, please?
>
> So what is your scenario for this issue. Multiple AP interfaces?

Arend, what should I do with this patchset?

-- 
Kalle Valo
