Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61201 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGTRO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 13:14:58 -0400
Message-ID: <55AD2C8F.9010509@broadcom.com> (sfid-20150720_191501_091385_781B8E7C)
Date: Mon, 20 Jul 2015 19:14:55 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
References: <1436553071-32423-1-git-send-email-arend@broadcom.com> <CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
In-Reply-To: <CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>> This series comprises of following changes:
>> - support NVRAM loading for bcm47xx platform.
>> - revise announced interface combinations and validate against it.
>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>> - couple of PCIe fixes.
>> - rework dealing with interface instances.
>
> I'm not sure which patch has caused this (I applied all of them except
> for the 1st one) but now brcmfmac fails totally:
>> Unable to handle kernel NULL pointer dereference at virtual address 00000014
>
> I'm afraid I won't be able to spend any more time of this soon, so can
> you try to reproduce this problem, please?

So what is your scenario for this issue. Multiple AP interfaces?

Regards,
Arend
