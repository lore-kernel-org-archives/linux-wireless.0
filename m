Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52558 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbEINse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:48:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: parsing aid while receiving association response
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1430757608-2365-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150509134833.6A64F140135@smtp.codeaurora.org> (sfid-20150509_154836_639192_F63AA5EA)
Date: Sat,  9 May 2015 13:48:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> cfg80211 would complain about invalid AID in during TDLS setup.
> This was happening because we use same AID value as provide by AP
> while forming setup messages.
> Parse AID from Association response and filter BIT14 and BIT15
> of AID to get valid AID.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
