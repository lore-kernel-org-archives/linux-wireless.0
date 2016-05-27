Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52614 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbcE0Rwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 13:52:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: add fallback for devices that do not report
 per-chain values
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463070308-30789-1-git-send-email-jjmeijer88@gmail.com>
To: Jaap Jan Meijer <jjmeijer88@gmail.com>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
	brcm80211-dev-list@broadcom.com,
	Jaap Jan Meijer <jjmeijer88@gmail.com>
Message-Id: <20160527175249.C5F98613B2@smtp.codeaurora.org> (sfid-20160527_195254_452217_D0E98A58)
Date: Fri, 27 May 2016 17:52:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaap Jan Meijer <jjmeijer88@gmail.com> wrote:
> If brcmf_cfg80211_get_station fails to determine the RSSI from the
> per-chain values get the value individually as a fallback.
> 
> Fixes: 1f0dc59a6de9 ("brcmfmac: rework .get_station() callback")
> Signed-off-by: Jaap Jan Meijer <jjmeijer88@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers.git:

94abd778a7bb brcmfmac: add fallback for devices that do not report per-chain values

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9084101/

