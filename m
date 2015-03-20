Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51279 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbCTGbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 02:31:02 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: cw1200: Fix suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426425980-21743-1-git-send-email-lars@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-wireless@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Message-Id: <20150320063102.4370C140B88@smtp.codeaurora.org> (sfid-20150320_073106_015153_B5F02589)
Date: Fri, 20 Mar 2015 06:31:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The cw1200 driver implements suspend and resume callbacks and assigns them
> to the suspend and resume fields of the device_driver struct. These
> callbacks are never actually called by anything though.
> 
> Modify the driver to properly use dev_pm_ops so that the suspend function
> is actually executed upon suspend and drop the empty resume function.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
