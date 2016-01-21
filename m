Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43814 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbcAUNyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:54:21 -0500
From: "Mishol, Guy" <guym@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore: fix return value of wlcore_event_fw_logger
Date: Thu, 21 Jan 2016 13:54:17 +0000
Message-ID: <D9CB4E84-44C4-4528-AC63-6BD4ED1948FB@ti.com> (sfid-20160121_145426_422005_266E4634)
References: <1453109702-15750-1-git-send-email-guym@ti.com>,<8760ynyr80.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760ynyr80.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cool. Thanks!

Sent from my iPhone

> On Jan 21, 2016, at 15:52, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> Guy Mishol <guym@ti.com> writes:
> 
>> The function can return negative values in case of error.
>> Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")
>> 
>> Signed-off-by: Guy Mishol <guym@ti.com>
> 
> Andrzej already submitted identical patch:
> 
> https://patchwork.kernel.org/patch/7977461/
> 
> So I'm dropping this.
> 
> -- 
> Kalle Valo
