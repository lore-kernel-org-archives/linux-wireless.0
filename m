Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34161 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbBDI4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 03:56:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add TxBF support
References: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Feb 2015 10:55:59 +0200
In-Reply-To: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 30 Jan 2015 10:50:52 +0100")
Message-ID: <87zj8ut5r4.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_095617_011742_DC8AB186)
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

There was a trivial conflict in ath10k_bss_disassoc(), please check my
conflict resolution in the pending branch.

-- 
Kalle Valo
