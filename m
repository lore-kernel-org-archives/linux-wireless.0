Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58442 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbcD0Nx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 09:53:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: disable channel filtering feature in firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461566992-3539-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160427135322.3A4DC612F0@smtp.codeaurora.org> (sfid-20160427_155338_274354_C5698C89)
Date: Wed, 27 Apr 2016 13:53:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> As 2.4Ghz channels are overlapping, sometimes AP responds to
> probe request even if it's operating on neighbouring channel.
> Currently firmware drops those scan entries, as current channel
> doesn't match with APs channel.
> 
> This patch enables MWIFIEX_DISABLE_CHAN_FILT flag in scan
> command to disable the feature so that better scan results
> will be received in 2.4Ghz band.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

1b499cb72f26 mwifiex: disable channel filtering feature in firmware
9d3f65b0c2dd mwifiex: increase dwell time for active scan

Kalle Valo
