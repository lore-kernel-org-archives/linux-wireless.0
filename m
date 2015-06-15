Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:4533 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbbFOSWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 14:22:02 -0400
Message-ID: <557F17BF.9060601@broadcom.com> (sfid-20150615_202206_782174_F62D3DB6)
Date: Mon, 15 Jun 2015 20:21:51 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>
Subject: Re: [1/7] brcmfmac: Check if firmware supports p2p
References: <20150615101022.23F92140C1F@smtp.codeaurora.org>
In-Reply-To: <20150615101022.23F92140C1F@smtp.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/15 12:10, Kalle Valo wrote:
>
>> From: Pontus Fuchs<pontusf@broadcom.com>
>>
>> Add a feature flag to reflect the firmware's p2p capability.
>>
>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>> Reviewed-by: Hante Meuleman<meuleman@broadcom.com>
>> Reviewed-by: Arend Van Spriel<arend@broadcom.com>
>> Signed-off-by: Pontus Fuchs<pontusf@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>
> Thanks, 7 patches applied to wireless-drivers-next.git:
>
> 2b560d7148eb brcmfmac: Check if firmware supports p2p
> 2e5f66fe9593 brcmfmac: Build wiphy mode and interface combinations dynamically
> 1f0dc59a6de9 brcmfmac: rework .get_station() callback
> 5768f31e4e75 brcmfmac: have sdio return -EIO when device communication is not possible
> f37d69a4babc brcmfmac: free ifp for non-netdev interface in p2p module
> 55479df8840d brcmfmac: move p2p attach/detach functions
> f7a40873d2fa brcmfmac: assure p2pdev is unregistered upon driver unload

Hi Kalle,

As it turns out two patches in this series introduced a new issue (I had 
one of those days :-( ). I have fixes for them. Should I send them now 
or can it wait until 4.2-rc1 has landed.

Regards,
Arend

> Kalle Valo

