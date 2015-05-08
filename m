Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46405 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbEHNBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 09:01:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Modify REG_BCN_MAX_ERR related code.
References: <1430841518-3932-1-git-send-email-ap420073@gmail.com>
Date: Fri, 08 May 2015 16:01:05 +0300
In-Reply-To: <1430841518-3932-1-git-send-email-ap420073@gmail.com> (Taehee
	Yoo's message of "Wed, 6 May 2015 00:58:38 +0900")
Message-ID: <87pp6bp6jy.fsf@kamboji.qca.qualcomm.com> (sfid-20150508_150116_749011_82651808)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

> 1. Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
> Initialization routine set REG_BCN_MAX_ERR to 0xFF.
> also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
> so i remove this code.
>
> 2. Remove rtl92c_init_beacon_max_error's parameter.
> because parameter "infra_mode" is not used.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Please split the patches into two. Having a numbered list of changes in
the commit log is a strong indication that the patch should be split
into smaller patches.

-- 
Kalle Valo
