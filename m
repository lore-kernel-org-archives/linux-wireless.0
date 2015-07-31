Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38653 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbGaGYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 02:24:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: b43: fix extpa_gain check for 2GHz
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: kvalo@qca.qualcomm.com, zajec5@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Message-Id: <20150731062432.C8FD5140A57@smtp.codeaurora.org> (sfid-20150731_082436_522065_E5087F2B)
Date: Fri, 31 Jul 2015 06:24:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
> the 5GHz band was checked. this patch makes it check the property from
> the correct band.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied to wireless-drivers.git.

Kalle Valo
