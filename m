Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51277 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEIQ3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 12:29:52 -0400
Message-ID: <554E35FE.4060805@broadcom.com> (sfid-20150509_182956_394249_3D3DE3A8)
Date: Sat, 9 May 2015 18:29:50 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] brcmfmac: device support and fixes
References: <1429035033-14076-1-git-send-email-arend@broadcom.com> <87oaltltlh.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oaltltlh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/15 16:21, Kalle Valo wrote:
> Hi Arend,
>
> Arend van Spriel<arend@broadcom.com>  writes:
>
>> This series include some fixes related to SDIO suspend and resume,
>> wiphy band info and changes in regulatory settings. Furthermore,
>> support for BCM4324 SDIO and BCM4358 PCIe is added. Finally,
>> some patches from Hante that should enable support of PCIe devices
>> on router platforms.
>
> Your patch series are always top notch but I still would like to ask for
> one small formatting change :) It would make my life easier if you could
> list the major changes like this:
>
> * SDIO suspend and resume fixes
> * wiphy band info and changes in regulatory settings
> * add support for BCM4324 SDIO and BCM4358 PCIe
> * enable support of PCIe devices on router platforms (Hante)
>
> That way I could directly copy your list to the pull request I send to
> Dave.

No problem. We want our lives to be as easy as possible ;-)

Regards,
Arend

