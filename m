Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35811 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbHTPvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:51:22 -0400
Received: by iodt126 with SMTP id t126so51020759iod.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 08:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D5AAA5.1080700@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
	<55AD2C8F.9010509@broadcom.com>
	<CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>
	<55CB0ACA.3000109@broadcom.com>
	<CACna6ryZ6qJY7t12CQjyD1kvkXa5kpQp3J+eyEq4Gn0DVR9TMA@mail.gmail.com>
	<55D5AAA5.1080700@broadcom.com>
Date: Thu, 20 Aug 2015 17:51:21 +0200
Message-ID: <CACna6rxVuhgea8C7KeWbfv31qGn=n=MxnJ+HBW2FHcVbviiYgQ@mail.gmail.com> (sfid-20150820_175125_894750_9947ABBF)
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 August 2015 at 12:23, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/20/2015 01:06 AM, Rafał Miłecki wrote:
>>
>> On 12 August 2015 at 10:58, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>> You did a warm reboot of the device, right? There seems to be an issue
>>> because on OpenWrt the brcmfmac is not unloaded upon warm reboot, which
>>> makes the device unaccessible. Because on OpenWrt the firmware request is
>>> synchronous (OpenWrt patch on top of upstream brcmfmac) it results in
>>> probe
>>> failing on invalid access making the issue OpenWrt specific. Hante
>>> created a
>>> fix for the warm reboot issue.
>>
>>
>> Hante could you share your fix?
>
>
> Hi Rafał,
>
> Just sent you the patch privately.

Seems to be working nice, thanks! I hope you'll be able to publish it soon :)

-- 
Rafał
