Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52248 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbbFOJrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:47:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: handle BT coex event to adjust Rx BA window size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433942388-28320-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Chunfan Chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150615094721.5B255140977@smtp.codeaurora.org> (sfid-20150615_114725_055454_9B097436)
Date: Mon, 15 Jun 2015 09:47:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Chunfan Chen <jeffc@marvell.com>
> 
> If timeshare coexistance between bluetooth and WLAN gets enabled,
> firmware will give host an event to reduce Rx AMPDU BA window size.
> The event is handled in this patch.
> 
> Signed-off-by: Chunfan Chen <jeffc@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
