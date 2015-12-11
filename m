Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40688 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbLKLOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:14:41 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: only lock and unlock fws if fws is not null
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1449056710-9776-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: kernel-tram@lists.ubuntu.com, Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20151211111440.67B29141A65@smtp.codeaurora.org> (sfid-20151211_121501_491117_0022E03C)
Date: Fri, 11 Dec 2015 11:14:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a null ptr check for fws to set bcmc_credit_check, however,
> there a lock and unlock on fws should only performed if fwts is
> also not null to also avoid a potential null pointer deference.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
