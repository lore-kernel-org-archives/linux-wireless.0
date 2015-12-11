Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56920 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbbLKIuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 03:50:02 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Shahar Patury <shaharp@ti.com>
Subject: Re: [PATCH V5] wlcore/wl18xx: fw logger over sdio
References: <1449151723-28387-1-git-send-email-guym@ti.com>
Date: Fri, 11 Dec 2015 10:49:55 +0200
In-Reply-To: <1449151723-28387-1-git-send-email-guym@ti.com> (Guy Mishol's
	message of "Thu, 3 Dec 2015 16:08:43 +0200")
Message-ID: <87io455pzg.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_095008_666057_49866DD0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> writes:

> From: Shahar Patury <shaharp@ti.com>
>
> enable the FW Logger to work over the SDIO interface instead of only
> over UART.
> in new design we will use fw internal memory instead of packet ram
> that was used in older (and wl12xx) design.
> this change will reduce the impact on tp and stability.
> adding new event to notify fw logger is ready to be read.
> adding dynamic configuration to debugfs.
>
> Signed-off-by: Shahar Patury <shaharp@ti.com>

If you submit a patch written by someone else you should add your own
Signed-off-by line. Hence I can't take this in this form, so please
resend.

Also please format your commit logs properly: use capitalisation,
cleanly word wrap the lines and so on. It should look like something you
could give your english teacher without she having a heart attack :)

-- 
Kalle Valo
