Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbcEMKmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 06:42:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jaap Jan Meijer <jjmeijer88@gmail.com>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2] brcmfmac: add fallback for devices that do not report per-chain values
References: <CAA+NYvRvVXF0-x9s8qDBaL0_Weuin5+CAsZXZu5Wt+_M1FGMWw@mail.gmail.com>
	<1463070308-30789-1-git-send-email-jjmeijer88@gmail.com>
Date: Fri, 13 May 2016 13:42:02 +0300
In-Reply-To: <1463070308-30789-1-git-send-email-jjmeijer88@gmail.com> (Jaap
	Jan Meijer's message of "Thu, 12 May 2016 18:25:08 +0200")
Message-ID: <874ma2ck91.fsf@kamboji.qca.qualcomm.com> (sfid-20160513_124215_211375_1235BB91)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaap Jan Meijer <jjmeijer88@gmail.com> writes:

> If brcmf_cfg80211_get_station fails to determine the RSSI from the
> per-chain values get the value individually as a fallback.
>
> Fixes: 1f0dc59a6de9 ("brcmfmac: rework .get_station() callback")
>
> Signed-off-by: Jaap Jan Meijer <jjmeijer88@gmail.com>
> ---
> change log:
> v2:
>  - remove beacon period and dtim, these values are obtained differently
>  - add reverence to fixed commit

If no objections I'm planning to send this to 4.7-rc2.

-- 
Kalle Valo
