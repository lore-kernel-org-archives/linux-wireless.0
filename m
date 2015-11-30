Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37174 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbbK3Mtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:49:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [01/11] brcmfmac: Cleanup ssid storage.
References: <20151130124816.E0B9B14089C@smtp.codeaurora.org>
Date: Mon, 30 Nov 2015 14:49:44 +0200
In-Reply-To: <20151130124816.E0B9B14089C@smtp.codeaurora.org> (Kalle Valo's
	message of "Mon, 30 Nov 2015 12:48:16 +0000 (UTC)")
Message-ID: <877fkzk5xz.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_134952_787905_3B0FA9B0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> From: Hante Meuleman <meuleman@broadcom.com>
>> 
>> SSIDs used for connect and p2p got stored, but never used.
>> 
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> Thanks, 10 patches applied to wireless-drivers-next.git:
>
> e9a6ca825eb7 brcmfmac: Cleanup ssid storage.
> 21000b3f3da4 brcmfmac: Return actual error by fwil.
> 6a23863eaa51 brcmfmac: Change error print on wlan0 existence.
> 64d66c30c37e brcmfmac: no retries on rxglom superframe errors
> c495810624ef brcmfmac: Remove redundant parameter action from scan.
> 1119e23edf25 brcmfmac: Cleanup roaming configuration.
> 7bf65aa9ad3f brcmfmac: Add beamforming support.
> b4fd63c608a2 brcmfmac: assure net_ratelimit() is declared before use
> 46d703a77539 brcmfmac: Unify methods to define and map firmware files.
> 5536f20a1c43 brcmfmac: Fix double free on exception at module load.

Forgot to mention that I skipped patch 8 for now as it needs more
discussion.

https://patchwork.kernel.org/patch/7697091/

-- 
Kalle Valo
