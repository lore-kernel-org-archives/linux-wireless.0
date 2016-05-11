Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbcEKSzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:55:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: Remove double check for cnt_after_linked
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160505150822.GA4151@udknight>
To: wang yanqing <udknight@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160511185539.51E2E6133D@smtp.codeaurora.org> (sfid-20160511_205602_035820_CBB34444)
Date: Wed, 11 May 2016 18:55:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wang yanqing <udknight@gmail.com> wrote:
> rtl_lps_enter does two successive check for cnt_after_linked
> to make sure some time has elapsed after linked. The second
> check isn't necessary, because if cnt_after_linked is bigger
> than 5, it is bigger than 2 of course!
> 
> This patch remove the second check code.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

976aff5fc94b rtlwifi: Remove double check for cnt_after_linked

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9025161/

