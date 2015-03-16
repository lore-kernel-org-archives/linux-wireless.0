Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36995 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935085AbbCPPxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 11:53:36 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] ath9k: restart only triggering DFS detector line
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426006171-2555-2-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-Id: <20150316155335.C1306141B74@smtp.codeaurora.org> (sfid-20150316_165346_059481_04C6977E)
Date: Mon, 16 Mar 2015 15:53:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> To support HT40 DFS mode, a triggering detector must
> reset only itself but not other detector lines.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

8252a35ab4f6 ath9k: restart only triggering DFS detector line
58766977ad12 ath9k: add DFS support for extension channel
387f149a2ace ath9k: allow 40MHz radar detection width

Kalle Valo
