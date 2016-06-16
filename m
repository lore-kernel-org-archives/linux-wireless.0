Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56542 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbcFPPD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:03:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V6] brcmfmac: print errors if creating interface fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464339268-27916-1-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20160616150350.E921C614DE@smtp.codeaurora.org> (sfid-20160616_170400_078481_081274D9)
Date: Thu, 16 Jun 2016 15:03:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> wrote:
> From: Rafał Miłecki <zajec5@gmail.com>
> 
> This is helpful for debugging. Without this all I was getting from "iw"
> command on failed creating of P2P interface was:
> > command failed: Too many open files in system (-23)
> 
> Signed-off-by: Rafal Milecki <zajec5@gmail.com>
> [arend@broadcom.com: reduce error prints upon iface creation]
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

0cd33c204b98 brcmfmac: print errors if creating interface fails

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9137911/

