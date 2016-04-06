Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33507 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcDFSkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:40:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wl12xx: remove redundant null check on wl->scan.ssid
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458318048-28184-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Eliad Peller <eliad@wizery.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160406184031.7925D615CF@smtp.codeaurora.org> (sfid-20160406_204059_043538_C18BB181)
Date: Wed,  6 Apr 2016 18:40:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Colin Ian King <colin.king@canonical.com>
> 
> ssid is an array of u8, so it can never be null, so the null check on
> wl->scan.ssid is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
