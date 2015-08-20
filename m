Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:1957 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbHTTlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 15:41:52 -0400
Message-ID: <55D62D7C.8000304@broadcom.com> (sfid-20150820_214155_649474_6713B253)
Date: Thu, 20 Aug 2015 21:41:48 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>	<55AD2C8F.9010509@broadcom.com>	<CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>	<55CB0ACA.3000109@broadcom.com>	<CACna6ryZ6qJY7t12CQjyD1kvkXa5kpQp3J+eyEq4Gn0DVR9TMA@mail.gmail.com>	<55D5AAA5.1080700@broadcom.com> <CACna6rxVuhgea8C7KeWbfv31qGn=n=MxnJ+HBW2FHcVbviiYgQ@mail.gmail.com>
In-Reply-To: <CACna6rxVuhgea8C7KeWbfv31qGn=n=MxnJ+HBW2FHcVbviiYgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2015 05:51 PM, Rafał Miłecki wrote:
> On 20 August 2015 at 12:23, Arend van Spriel <arend@broadcom.com> wrote:
>> On 08/20/2015 01:06 AM, Rafał Miłecki wrote:
>>>
>>> On 12 August 2015 at 10:58, Arend van Spriel <arend@broadcom.com> wrote:
>>>>
>>>> You did a warm reboot of the device, right? There seems to be an issue
>>>> because on OpenWrt the brcmfmac is not unloaded upon warm reboot, which
>>>> makes the device unaccessible. Because on OpenWrt the firmware request is
>>>> synchronous (OpenWrt patch on top of upstream brcmfmac) it results in
>>>> probe
>>>> failing on invalid access making the issue OpenWrt specific. Hante
>>>> created a
>>>> fix for the warm reboot issue.
>>>
>>>
>>> Hante could you share your fix?
>>
>>
>> Hi Rafał,
>>
>> Just sent you the patch privately.
>
> Seems to be working nice, thanks! I hope you'll be able to publish it soon :)

Not before monday and I suspect a merge window coming up, but I might be 
just paranoid ;-)

Regards,
Arend

