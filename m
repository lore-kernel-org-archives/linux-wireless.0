Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54998 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbbA2IB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 03:01:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/14] brcmfmac: Relax scheduling of msgbuf worker on
 highthroughput.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422214303-7816-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150129080128.4D06913EF18@smtp.codeaurora.org> (sfid-20150129_090133_411789_6A02CC5F)
Date: Thu, 29 Jan 2015 08:01:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> On every tx the flow worker is triggered. When running high
> throughput data this causes an excessive amount of times the worker
> gets activated. This patch starts scheduling the worker more relaxed
> once outstanding tx has reached a certain depth.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 14 patches applied to wireless-drivers-next.git:

5ef1e604194e brcmfmac: Relax scheduling of msgbuf worker on high throughput.
69d03ee0b709 brcmfmac: prevent possible deadlock on resuming SDIO device.
4dd8b26a40ac brcmfmac: use SDIO DPC for control frames.
9b7a0ddc6073 brcmfmac: pass DEAUTH/DISASSOC reason code to user-space
8982cd40ace9 brcmfmac: wait for driver to go idle during suspend
a1cee865c3e7 brcmfmac: SDIO: avoid using bus state for private states.
649f38ae9e48 brcmfmac: Reopen netdev queue on bus state data.
86fec35e17c1 brcmfmac: do not load firmware when device is already running
31fc436f184d brcmutil: use define for boardrev string function
9b1933a3bd7c brcmfmac: determine chip info when not provided by bus layer
4862290319ad brcmfmac: always obtain device revision info upon intialization
e749c7d49c20 brcmfmac: show firmware release info in ethtool driver info
7f52c81d02a2 brcmfmac: store revinfo retrieval result
4165fe9a9287 brcmfmac: fix nvram processing

Kalle Valo
