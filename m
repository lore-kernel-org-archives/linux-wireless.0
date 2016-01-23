Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbcAWUVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2016 15:21:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Carlo Caione <carlo@caione.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, arend@broadcom.com,
	meuleman@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] brcmfmac issue
References: <CAOQ7t2Z2E3vn+t9gDZKfs9Ke1aPEGObgSi2RZDzD7kPVR2LJzg@mail.gmail.com>
Date: Sat, 23 Jan 2016 22:20:53 +0200
In-Reply-To: <CAOQ7t2Z2E3vn+t9gDZKfs9Ke1aPEGObgSi2RZDzD7kPVR2LJzg@mail.gmail.com>
	(Carlo Caione's message of "Sat, 23 Jan 2016 19:09:33 +0100")
Message-ID: <87d1sst5cq.fsf@kamboji.qca.qualcomm.com> (sfid-20160123_212104_232659_0B1DA15C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carlo Caione <carlo@caione.org> writes:

> I submitted [1] e10c3219 "mmc: core: Enable tuning according to the
> actual timing"  to solve a problem with the BCM43340 SDIO WiFi card.
> This patch works perfectly fine on top of v4.4 tag, solving the
> problem with the WiFi card. With the latest master the asus x205ta
> laptop fails to boot. The failure seems related to a weird interaction
> between this patch and 7d34b05 "brcmfmac: Move all module parameters
> to one place" (bad commit).
>
> The bad commit was found bisecting between master and v4.4 and
> applying my patch when not already present.
>
> Here the log: https://gist.github.com/9db683a467496c942659
>
> Any idea?

Does this patch fix it?

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=e0045bf80f62779ba75ba04513020d60e59f5298

-- 
Kalle Valo
