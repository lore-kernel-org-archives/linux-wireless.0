Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26795 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbbCGHwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:52:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix broken traffic for 802.1x in client mode
References: <1424264547-2932-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 09:51:52 +0200
In-Reply-To: <1424264547-2932-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Feb 2015 14:02:26 +0100")
Message-ID: <87egp11bzb.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085205_479927_CF05F089)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> When running 802.1x WEP keys must be installed
> without pairwise-groupwise swap (which is
> necessary for static WEP).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
