Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34616 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbcEKSoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:44:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: Fix logic error in enter/exit power-save mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160502163835.GA10925@udknight>
To: wang yanqing <udknight@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160511184431.23F4D61322@smtp.codeaurora.org> (sfid-20160511_204455_122151_70F82A6B)
Date: Wed, 11 May 2016 18:44:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wang yanqing <udknight@gmail.com> wrote:
> In commit a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and
> rtl_lps_enter() to use work queue"), the tests for enter/exit
> power-save mode were inverted. With this change applied, the
> wifi connection becomes much more stable.
> 
> Fixes: a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue")
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> CC: Stable <stable@vger.kernel.org> [3.10+]
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

873ffe154ae0 rtlwifi: Fix logic error in enter/exit power-save mode

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8993841/

