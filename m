Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35935 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbcEKTB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:01:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fixup error messages
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1462861283-11103-1-git-send-email-wnhuang@chromium.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux-Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>
Message-Id: <20160511190125.982DC61324@smtp.codeaurora.org> (sfid-20160511_210153_677622_FF1C247B)
Date: Wed, 11 May 2016 19:01:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@chromium.org> wrote:
> Use dev_err instead of pr_err and add newline character at the end.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

50d4d8feb913 mwifiex: fixup error messages

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9054541/

