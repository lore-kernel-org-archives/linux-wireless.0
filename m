Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34855 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbHRGGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:06:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2,V2] wl18xx: update statistics acx and debugfs files
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1439276577-9585-1-git-send-email-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Message-Id: <20150818060630.3E06A1403B8@smtp.codeaurora.org> (sfid-20150818_080633_871501_808EEA7B)
Date: Tue, 18 Aug 2015 06:06:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Eliad Peller <eliad@wizery.com>
> 
> Sync the driver statistics acx and debugfs representation
> with the current fw api.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

c48276cbbeae wl18xx: update statistics acx and debugfs files
fc645df09392 wl18xx: add diversity statistics

Kalle Valo
