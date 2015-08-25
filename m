Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48074 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbHYMiC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:38:02 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rsi: Fix possible leak when loading firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1440191666-5104-1-git-send-email-cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: mike.looijmans@topic.nl, khoroshilov@ispras.ru,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Message-Id: <20150825123802.2C11B1405B0@smtp.codeaurora.org> (sfid-20150825_143827_757469_F09B9E49)
Date: Tue, 25 Aug 2015 12:38:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Commit 5d5cd85ff441 ("rsi: Fix failure to load firmware after memory
> leak fix and fix the leak") also added a check on the allocation of
> DMA-accessible memory that may directly return. In that case the
> already allocated firmware data is leaked. Make sure the data is
> always freed correctly. Detected by Coverity CID 1316519.
> 
> Fixes: 5d5cd85ff441 ("rsi: Fix failure to load firmware after memory leak fix and fix the leak")
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
