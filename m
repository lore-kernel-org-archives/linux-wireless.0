Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:34403 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbbAWRGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:06:37 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: do not emit messages while holding spinlock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1420634425-28306-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, Avinash Patil <patila@marvell.com>
Message-Id: <20150123170636.A6545141337@smtp.codeaurora.org> (sfid-20150123_180649_136580_FC14E7B1)
Date: Fri, 23 Jan 2015 17:06:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Avoid printing dev_{warn/dbg} messages while holding spinlock.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
