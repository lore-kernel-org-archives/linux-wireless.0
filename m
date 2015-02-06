Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37962 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbBFGhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:37:14 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RESEND,
 1/2] rtlwifi: rtl8192ee: Fix handling of new style descriptors
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422983718-21432-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20150206063713.C8380140C14@smtp.codeaurora.org> (sfid-20150206_073719_426906_1AF5ABFE)
Date: Fri,  6 Feb 2015 06:37:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Troy Tan <troy_tan@realsil.com.cn>
> 
> The hardware and firmware for the RTL8192EE utilize a FIFO list of
> descriptors. There were some problems with the initial implementation.
> The worst of these failed to detect that the FIFO was becoming full,
> which led to the device needing to be power cycled. As this condition
> is not relevant to most of the devices supported by rtlwifi, a callback
> routine was added to detect this situation. This patch implements the
> necessary changes in the pci handler, and the linkage into the appropriate
> rtl8192ee routine.
> 
> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V3.18]

Thanks, 2 patches applied to wireless-drivers-next.git:

d0311314d002 rtlwifi: rtl8192ee: Fix handling of new style descriptors
6d4beca37752 rtlwifi: rtl8192ee: Fix problems with calculating free space in FIFO

Kalle Valo
