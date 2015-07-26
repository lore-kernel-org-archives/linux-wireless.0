Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51320 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbbGZL4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 07:56:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	manabian@gmail.com
Subject: Re: [PATCH] bcma: fix build error when build as module
References: <1437851427-7485-1-git-send-email-hauke@hauke-m.de>
Date: Sun, 26 Jul 2015 14:56:31 +0300
In-Reply-To: <1437851427-7485-1-git-send-email-hauke@hauke-m.de> (Hauke
	Mehrtens's message of "Sat, 25 Jul 2015 21:10:27 +0200")
Message-ID: <87lhe3b09c.fsf@kamboji.qca.qualcomm.com> (sfid-20150726_135751_243990_E4CA659D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> Currently of_default_bus_match_table is not exported so we can only use
> this feature when bcma is build into the kernel. This patch removes
> support for child buses when bcma is build as a module as a temporary
> fix for a build problem introduces in this commit:
>
> commit cae761b5a6bdc597ba476a040fdcd5b4bc559b85
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Sun Jun 28 17:17:13 2015 +0200
>
>     bcma: populate bus DT subnodes as platform_device-s
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, manually applied to wireless-drivers-next.git. (Still
patchwork.kernel.org has buggy utf-8 support, sigh.) I just added
Reported-by and Fixes lines to the commit log.

I wrote a similar patch but I'll drop that as your has better comments :)

-- 
Kalle Valo
