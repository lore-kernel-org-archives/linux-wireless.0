Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbcASMz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 07:55:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH] brcmfmac: fix sdio sg table alloc crash
References: <1453203564-15974-1-git-send-email-arend@broadcom.com>
Date: Tue, 19 Jan 2016 14:55:49 +0200
In-Reply-To: <1453203564-15974-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Tue, 19 Jan 2016 12:39:24 +0100")
Message-ID: <87egdd684q.fsf@kamboji.qca.qualcomm.com> (sfid-20160119_135629_866941_7D3AB13C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> With commit 7d34b0560567 ("brcmfmac: Move all module parameters to
> one place") a bug was introduced causing a null pointer exception.
> This patch fixes the bug by initializing the sg table till after
> the settings have been initialized.
>
> Reported-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, I'm planning to push this to 4.5.

-- 
Kalle Valo
