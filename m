Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51987 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbcDGQjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:39:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: ie_list is an array, so no need to check if NULL
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1459180413-13288-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160407163941.00A54611CD@smtp.codeaurora.org> (sfid-20160407_184009_433962_F7C4ED27)
Date: Thu,  7 Apr 2016 16:39:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Colin Ian King <colin.king@canonical.com>
> 
> ap_ie->ie_list is an array of struct mwifiex_ie and can never
> be null, so the null check on this array is redundant and can
> be removed.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
