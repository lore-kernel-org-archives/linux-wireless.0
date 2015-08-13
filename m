Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55654 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbHMMgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:36:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: claim sdio bus while downloading the firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438846756-30520-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150813123633.10EEE140658@smtp.codeaurora.org> (sfid-20150813_143636_112492_5BF1FA29)
Date: Thu, 13 Aug 2015 12:36:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Aniket Nagarnaik <aniketn@marvell.com>
> 
> Our 8887 A2 chip can have separate firmware images for
> bluetooth and WLAN. We observed an issue during parallel
> downloading of these images by btmrvl and mwifiex drivers.
> 
> This patch claims sdio bus before starting of the firmware
> download in mwifiex and releases it after completion to
> fix the problem.
> 
> Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
