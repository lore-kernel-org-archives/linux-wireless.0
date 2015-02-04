Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2500 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbBDHVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 02:21:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH-RESEND] ath10k: add log level configuration for fw_dbglog
References: <1422522412-10441-1-git-send-email-sjegadee@qti.qualcomm.com>
Date: Wed, 4 Feb 2015 09:21:35 +0200
In-Reply-To: <1422522412-10441-1-git-send-email-sjegadee@qti.qualcomm.com>
	(SenthilKumar Jegadeesan's message of "Thu, 29 Jan 2015 14:36:52
	+0530")
Message-ID: <871tm6w39c.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_082209_469145_DFE91700)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com> writes:

> Introduce optional log level configuration for
> existing debugfs fw_dbglog.
>
> It allow users to configure desired log level
> for firmware debugs.
>
> To configure log level as WARN
>
> echo 0xffffffff  2 > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog
>
> Loglevel	Value
> VERBOSE		0
> INFO		1
> WARN		2
> ERR		3
>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
