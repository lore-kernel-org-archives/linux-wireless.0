Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48310 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbbBOPQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 10:16:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add TxBF support
References: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com>
Date: Sun, 15 Feb 2015 17:16:06 +0200
In-Reply-To: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 30 Jan 2015 10:50:52 +0100")
Message-ID: <87r3trgq89.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_161618_435385_A7158804)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If firmware advertises support for TxBF then the
> driver has to instruct the firmware accordingly
> during runtime. Without this patch connecting to
> an AP with beamformer support would yield abysmal
> Rx performance.
>
> This has been tested with wmi-tlv and qca6174
> while acting as a STA beamformee only.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
