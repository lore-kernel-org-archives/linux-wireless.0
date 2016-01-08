Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34268 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbcAHIpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 03:45:19 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: Add wowl net detect support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451988350-2197-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20160108084519.11356605C3@smtp.codeaurora.org> (sfid-20160108_094528_208882_70B03102)
Date: Fri,  8 Jan 2016 08:45:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> With wowl net detect it becomes possible to scan for specific ssids
> and wakeup once found.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

3021ad9a4f00 brcmfmac: Add wowl net detect support
5419f7f17d5b brcmfmac: Reshuffle functions to avoid forward declarations
4011fc499690 brcmfmac: change brcmf_sdio_wd_timer() prototype
63ce3d5db093 brcmfmac: use msecs_to_jiffies() in macro definitions
5ce96c0808ac brcmfmac: use jiffies for timeout in btcoex
42e0ed0d454c brcmfmac: Do not handle link downs for ibss.

Kalle Valo
