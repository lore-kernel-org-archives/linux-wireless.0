Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34512 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbcEKSnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:43:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl818x: constify rtl_intf_ops structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1462132664-1619-1-git-send-email-Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	kernel-janitors@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160511184318.B822E6133D@smtp.codeaurora.org> (sfid-20160511_204342_710425_B006EF49)
Date: Wed, 11 May 2016 18:43:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> The rtl_intf_ops structures are never modified, so declare them as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, 1 patch applied to wireless-drivers-next.git:

1bfcfdcca142 rtlwifi: rtl818x: constify rtl_intf_ops structures

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8989291/

