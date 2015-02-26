Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59410 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbbBZNTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:19:54 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/1] rtlwifi: Clear ACM_CTRL AC3_VO bit correctly
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423261472-4607-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	wlanfae@realtek.com, Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20150226131953.68A071409A2@smtp.codeaurora.org> (sfid-20150226_141957_123447_42172CB5)
Date: Thu, 26 Feb 2015 13:19:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> All hw driver components in the rtlwifi driver, except for the
> rtl8192de component has this bug. They would clear BE bit in the
> ACM_CTRL register instead of the VO bit when processing the VO queue.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
