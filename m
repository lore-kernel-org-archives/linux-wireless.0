Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbGKQvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:51:02 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ipw2100: fix timeout bug - always evaluated to 0
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434389075-4693-1-git-send-email-hofrat@osadl.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Message-Id: <20150711165101.3F8BD13F56E@smtp.codeaurora.org> (sfid-20150711_185132_113823_EE22E173)
Date: Sat, 11 Jul 2015 16:51:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> commit 2c86c275015c ("Add ipw2100 wireless driver.") introduced 
> HW_PHY_OFF_LOOP_DELAY (HZ / 5000) which always evaluated to 0. Clarified
> by Stanislav Yakovlev <stas.yakovlev@gmail.com> that it should be 50
> milliseconds thus fixed up to msecs_to_jiffies(50).
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
