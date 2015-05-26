Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57207 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbbEZNiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:38:00 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: allow device tree node without 'interrupts'
 property
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432123792-4155-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150526111026.A5AB4141835@smtp.codeaurora.org> (sfid-20150526_153812_114703_A7B16A94)
Date: Tue, 26 May 2015 11:10:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> As described in the device tree bindings for 'brcm,bcm4329-fmac'
> nodes, the interrupts property is optional. So adding a check
> for the presence of this property before attempting to parse
> and map the interrupt. If not present or parsing fails return
> and fallback to in-band sdio interrupt.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 5 patches applied to wireless-drivers-next.git:

f58001fa9570 brcmfmac: allow device tree node without 'interrupts' property
464a5f3f0429 brcmfmac: Improve throughput by scheduling msbug flow worker.
fd5e8cb8178a brcmfmac: remove pci shared structure rev4 support
c2d4182edc05 brcmfmac: remove dummy cache flush/invalidate function
f3550aeb7fcd brcmfmac: add support for dma indices feature

Kalle Valo
