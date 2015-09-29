Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35675 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbbI2HnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:43:13 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: Add support for OCB mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442491426-15233-1-git-send-email-kaisrja1@fel.cvut.cz>
To: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: kaisrja1@fel.cvut.cz, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de, nbd@openwrt.org,
	Michal Sojka <sojkam1@fel.cvut.cz>
Message-Id: <20150929074312.5DB17140D97@smtp.codeaurora.org> (sfid-20150929_094316_065117_CA306FE5)
Date: Tue, 29 Sep 2015 07:43:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The patch adds support for "outside the context of a BSS"(OCB) mode
> to ath9k driver and extends debugfs files by OCB ralated information.
> 
> This patch was tested on AR9380-AL1A cards.
> 
> Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
> Cc: Michal Sojka <sojkam1@fel.cvut.cz>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
