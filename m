Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50104 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbIUKYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 06:24:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: RUC_Soft_Sec <zy900702@163.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net] Fix error handling in ezusb_probe()
References: <4fb5a5fe.340c.14fe3857f23.Coremail.zy900702@163.com>
Date: Mon, 21 Sep 2015 13:24:02 +0300
In-Reply-To: <4fb5a5fe.340c.14fe3857f23.Coremail.zy900702@163.com> (RUC Soft
	Sec's message of "Sat, 19 Sep 2015 10:53:41 +0800 (CST)")
Message-ID: <87eghsqddp.fsf@kamboji.qca.qualcomm.com> (sfid-20150921_122432_065735_686EB33A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RUC_Soft_Sec <zy900702@163.com> writes:

> Current code assigns 0 to variable 'retval', which makes ezusb_probe()
> to return success even if alloc_orinocodev() fails.
>
> Fix it by checking the return value from alloc_orinocodev() and
> assigns '-ENOMEM' to variable 'retval' in the case of error.
>
>
> Signed-off-by: RUC_Soft_Sec <zy900702@163.com>

Please use your real name both in From header and in Signed-off-by line.
Also use "orinoco_usb:" as the prefix in the commit title.

> ---
>  orinoco_usb.c |    1 +
>  1 file changed, 1 insertion(+)

This is wrong, the patch should contain the full source path.


-- 
Kalle Valo
