Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31461 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbbDQGem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 02:34:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add extra check for frame tracing
References: <1428670948-7665-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 17 Apr 2015 09:34:32 +0300
In-Reply-To: <1428670948-7665-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:02:28 +0000")
Message-ID: <87r3rj4613.fsf@kamboji.qca.qualcomm.com> (sfid-20150417_083502_546380_43AA4448)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Frames are logged via tracing in two slices:
> header and payload, separately. This is done for
> performance reasons when one wants to, e.g.
> analyse metadata only of frames only.
>
> If for some reason device delivered a frame buffer
> which was sized below what 802.11 header implied
> tracing logic would blow doing an invalid memory
> accesses.
>
> I've hit this problem when running IBSS on QCA988X
> with 999.999.0.636 and tracing at the same time.
>
> Fixes: 5ce8e7fdcc7a ("ath10k: handle ieee80211 header and payload tracing separately")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
