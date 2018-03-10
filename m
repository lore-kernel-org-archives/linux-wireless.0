Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbeCJJ5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 04:57:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: s.gottschall@dd-wrt.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k: fix crash in spectral scan
References: <20180303041044.26372-1-s.gottschall@dd-wrt.com>
Date: Sat, 10 Mar 2018 11:57:12 +0200
In-Reply-To: <20180303041044.26372-1-s.gottschall@dd-wrt.com> (s. gottschall's
        message of "Sat, 3 Mar 2018 05:10:44 +0100")
Message-ID: <87zi3gb6dj.fsf@kamboji.qca.qualcomm.com> (sfid-20180310_105720_735933_5641827C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s.gottschall@dd-wrt.com writes:

> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>
> fixes crash seen on arm smp systems (gateworks ventana imx6)
>
> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>
> v2: fix wrong field and add signed-off-by
> v3: forgot to include correct latest patch, so just fix that and refresh

The changelog needs to be after "---" line so that git-am automatically
drops it, but I can fix that during commit.

-- 
Kalle Valo
