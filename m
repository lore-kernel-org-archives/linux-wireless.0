Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:20032 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbK3L7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 06:59:37 -0500
Message-ID: <565C3A27.4020903@broadcom.com> (sfid-20151130_125940_637693_B3AEF985)
Date: Mon, 30 Nov 2015 12:59:35 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [1/9] brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
References: <20151126115754.97089141133@smtp.codeaurora.org>	<56581B68.90501@broadcom.com> <87fuznka81.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fuznka81.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2015 12:17 PM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> Actually, the patch above should have been submitted to
>> wireless-drivers as it solves a suspend/hibernate issue with 4350
>> device which we added in 4.4.
>
> Just to avoid any confusion you are meaning this commit:
>
> c2a43a6ba5e5 brcmfmac: Use new methods for pcie Power Management.
>
>> How should I handle that? This is what I was thinking:
>>
>> 1. submit revert for wireless-drivers-next.
>> 2. submit patch of c2a43a6ba5e5 for wireless-drivers.
>
> That's just messy and would prefer to avoid that. I think the best would
> be that you send the patch to 4.4-stable queue once the commit goes to
> Linus' tree during the next merge window. That way you get the fix to
> first 4.4.x stable releases. But not sure if it's eligible for a stable
> fix.
>
> BTW, I recommend sending patches to -rc release separately from the rest
> and marking them with intended the release number like "[PATCH 4.4]".
> That way it's clear for me to which tree you would like me to apply the
> patch.

We do that but not very often so probably did not happen in your 
maintainer period (yet).

Regards,
Arend
