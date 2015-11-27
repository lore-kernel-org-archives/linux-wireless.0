Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:27981 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbbK0I7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:59:22 -0500
Message-ID: <56581B68.90501@broadcom.com> (sfid-20151127_095925_560891_4BFE7ABA)
Date: Fri, 27 Nov 2015 09:59:20 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [1/9] brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
References: <20151126115754.97089141133@smtp.codeaurora.org>
In-Reply-To: <20151126115754.97089141133@smtp.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2015 12:57 PM, Kalle Valo wrote:
>
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> Thanks, 9 patches applied to wireless-drivers-next.git:
>
> 2aff030355b5 brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
> c9c0043894cf brcmfmac: Simplify and fix usage of brcmf_ifname.
> 31fa86cb342b brcmfmac: Remove unnecessary check from start_xmit.
> da402c56bc91 brcmfmac: Remove unncessary variable irq_requested.
> dc1a272ec440 brcmfmac: Disable runtime pm for USB.
> 8abffd8173a1 brcmfmac: Add RSDB support.
> 37a869ec8593 brcmfmac: Use consistent naming for bsscfgidx.
> c2a43a6ba5e5 brcmfmac: Use new methods for pcie Power Management.

Hi Kalle,

Actually, the patch above should have been submitted to wireless-drivers 
as it solves a suspend/hibernate issue with 4350 device which we added 
in 4.4. How should I handle that? This is what I was thinking:

1. submit revert for wireless-drivers-next.
2. submit patch of c2a43a6ba5e5 for wireless-drivers.

Regards,
Arend

> aeb64225aa8e brcmfmac: Add wowl wake indication report.
>
> Kalle Valo
>

