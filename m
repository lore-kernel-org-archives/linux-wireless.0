Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbcDNNEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 09:04:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix the incorrect WARN_ON during suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460065032-23043-1-git-send-email-vishalthanki@gmail.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: akarwar@marvell.com, nishants@marvell.com, afenkart@gmail.com,
	linux-wireless@vger.kernel.org,
	Vishal Thanki <vishalthanki@gmail.com>
Message-Id: <20160414130415.33D5160DB9@smtp.codeaurora.org> (sfid-20160414_150423_730447_A3994F1F)
Date: Thu, 14 Apr 2016 13:04:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> During system suspend, there is a kernel WARNING issued if there
> is a pending command present. By marking the wait queue disabled
> after calling the command completion routine fixes it.
> 
> Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
