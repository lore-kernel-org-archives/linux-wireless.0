Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47927 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbHYMdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:33:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V3,1/6] brcmfmac: correct interface combination info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1440101168-2252-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150825123322.A94D014056E@smtp.codeaurora.org> (sfid-20150825_143329_077655_ABA0C598)
Date: Tue, 25 Aug 2015 12:33:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The interface combination provided by brcmfmac did not truly reflect
> the combinations supported by driver and/or firmware.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Pontus Fuchs <pontusf@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

0882dda3bcbb brcmfmac: correct interface combination info
2bb66a8183d6 brcmfmac: add debugfs entry for msgbuf statistics
39504a2d21ad brcmfmac: make use of cfg80211_check_combinations()
b02bf1932a48 brcmfmac: block the correct flowring when backup queue overflow
fc7c3ad5251c brcmfmac: bump highest event number for 4339 firmware
4e70f2144db0 brcmfmac: Add support for host platform NVRAM loading.

Kalle Valo
