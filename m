Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43870 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbbAWThm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:37:42 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: p54pci: add handling of signal case
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421731577-13324-1-git-send-email-der.herr@hofr.at>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Message-Id: <20150123193741.62BD8141EB5@smtp.codeaurora.org> (sfid-20150123_203800_546992_DF4F3BBE)
Date: Fri, 23 Jan 2015 19:37:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> if(!wait_for_completion_interruptible_timeout(...))
> only handles the timeout case - this patch adds handling the
> signal case the same as timeout.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Thanks, applied to wireless-drivers-next.git. I remove the useless "wireless: "
from the title.

Kalle Valo
