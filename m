Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58231 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbbGUNuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:50:16 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix leak of gen_ie storage on exit from
 mwifiex_del_mgmt_ies
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435346976-29030-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20150721135015.936221410C6@smtp.codeaurora.org> (sfid-20150721_155020_442119_9EE2BF55)
Date: Tue, 21 Jul 2015 13:50:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Storage pointed to by gen_ie is allocated with kmalloc, but was
> never freed.
> 
> Coverity CID #1271251
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
