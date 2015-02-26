Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59601 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbbBZNV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:21:58 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_htc: Add new USB ID
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423336207-4385-1-git-send-email-leon.nardella@gmail.com>
To: Leon Nardella <leon.nardella@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Leon Nardella <leon.nardella@gmail.com>
Message-Id: <20150226132157.488E41409FF@smtp.codeaurora.org> (sfid-20150226_142201_615791_C87851D1)
Date: Thu, 26 Feb 2015 13:21:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This device is a dongle made by Philips to enhance their TVs with wireless capabilities,
> but works flawlessly on any upstream kernel, provided that the ath9k_htc module is attached to it.
> It's correctly recognized by lsusb as "0471:209e Philips (or NXP) PTA01 Wireless Adapter" and the
> patch has been tested on real hardware.
> 
> Signed-off-by: Leon Nardella <leon.nardella@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
