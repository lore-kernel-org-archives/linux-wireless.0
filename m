Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbcDGQk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:40:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RESEND] mwifiex: fix NULL pointer dereference error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1459332895-4563-1-git-send-email-wnhuang@chromium.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, djkurtz@chromium.org,
	snanda@chromium.org, akarwar@marvell.com,
	Wei-Ning Huang <wnhuang@chromium.org>
Message-Id: <20160407164055.0296A615D4@smtp.codeaurora.org> (sfid-20160407_184111_586443_9A42C7EF)
Date: Thu,  7 Apr 2016 16:40:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In mwifiex_enable_hs, we need to check if
> priv->wdev.wiphy->wowlan_config is NULL before accessing its member.
> This sometimes cause kernel panic when suspend/resume.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
