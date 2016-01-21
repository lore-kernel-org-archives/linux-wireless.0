Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:18:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Eli Cooper <elicooper@gmx.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] rt2x00: fix monitor mode regression
References: <1453116619-29933-1-git-send-email-elicooper@gmx.com>
Date: Thu, 21 Jan 2016 15:18:51 +0200
In-Reply-To: <1453116619-29933-1-git-send-email-elicooper@gmx.com> (Eli
	Cooper's message of "Mon, 18 Jan 2016 19:30:19 +0800")
Message-ID: <87lh7jyssk.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_141900_642535_F5D356C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eli Cooper <elicooper@gmx.com> writes:

> Since commit df1404650ccb ("mac80211: remove support for IFF_PROMISC")
> monitor mode for rt2x00 has been made effectively useless because the
> hardware filter is configured to drop packets whose intended recipient is
> not the device, regardless of the presence of monitor mode interfaces.
>
> This patch fixes this regression by adding explicit monitor mode support,
> and by configuring the hardware filter accordingly.
>
> Changes in v3:
>   introduce and use CONFIG_MONITORING in rt2x00_state_flags
>   remove unnecessary debug messages
>   improve patch format
>
> Changes in v2:
>   fix patch format

No changelog inside the commit log, please. Instead add them under "---"
line so that git will ignore them. I can fix it this time.

> Signed-off-by: Eli Cooper <elicooper@gmx.com>

I'll queue this to 4.5.

-- 
Kalle Valo
