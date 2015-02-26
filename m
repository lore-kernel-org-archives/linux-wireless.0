Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbbBZNGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:06:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: use alloc_workqueue's format strings capabilities for
 WQnames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423232885-10073-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	<keescook@chromium.org>, Avinash Patil <patila@marvell.com>
Message-Id: <20150226130609.F3E931405D0@smtp.codeaurora.org> (sfid-20150226_140614_598291_DED5CBBA)
Date: Thu, 26 Feb 2015 13:06:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> alloc_workqueue() has string format formation ability e.g. wqname%ifname
> will be treated as wqnameifname. Use this and remove string operations
> while defining strings for workqueue names.
> 
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
