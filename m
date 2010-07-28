Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48989 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0G1Uo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 16:44:28 -0400
Message-ID: <4C5094BB.6070105@adurom.com>
Date: Wed, 28 Jul 2010 23:36:11 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: add get_survey callback in order to get channel
 noise
References: <1280345147-24137-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280345147-24137-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2010 10:25 PM, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> The calculation of the noise value looks a bit strange to me, but this
> is the same calculation from commit 446cfaa412beef0dd6cb0edf3b4eaed34d824537,
> some hopefully it was/is correct (or good enough)...

I never was able to find out proper way to measure noise with wl1251.
The algorithm I came up and included in this patch is most likely
incorrect. But as having support for noise survey doesn't do any harm,
and hopefully we even might motivate someone to fix the algorithm, I
think it's safe to have this patch.

Acked-by: Kalle Valo <kvalo@adurom.com>
