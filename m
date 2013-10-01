Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61469 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3JAQqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 12:46:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vladimir Murzin <murzin.v@gmail.com>
CC: <netdev@vger.kernel.org>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: fix compilation warning in ath6kl_htc_pipe_conn_service
References: <1380462871-2649-1-git-send-email-murzin.v@gmail.com>
Date: Tue, 1 Oct 2013 19:46:23 +0300
In-Reply-To: <1380462871-2649-1-git-send-email-murzin.v@gmail.com> (Vladimir
	Murzin's message of "Sun, 29 Sep 2013 15:54:31 +0200")
Message-ID: <871u456isg.fsf@kamboji.qca.qualcomm.com> (sfid-20131001_184636_420207_6620DF9F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Murzin <murzin.v@gmail.com> writes:

> Fix the warning
>
> drivers/net/wireless/ath/ath6kl/htc_pipe.c: In function
> 'ath6kl_htc_pipe_conn_service':
> drivers/net/wireless/ath/ath6kl/htc_pipe.c:1293:26: warning: integer overflow
> in expression [-Woverflow]
>
> by giving a hint to compiler about unsigned nature of
> HTC_CONN_FLGS_SET_RECV_ALLOC_MASK
>
> Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
