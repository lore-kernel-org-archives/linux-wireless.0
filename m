Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbLKLtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:49:15 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: fix memory leak for USB device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1449446851-2221-1-git-send-email-peter@lekensteyn.nl>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <20151211114914.D9353141D2E@smtp.codeaurora.org> (sfid-20151211_124934_002894_1B6D8808)
Date: Fri, 11 Dec 2015 11:49:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Free skb for received frames with a wrong checksum. This can happen
> pretty rapidly, exhausting all memory.
> 
> This fixes a memleak (detected with kmemleak). Originally found while
> using monitor mode, but it also appears during managed mode (once the
> link is up).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
