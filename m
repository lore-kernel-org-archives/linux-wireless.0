Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37026 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbbI2H6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:58:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: include linux/atomic.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442659640-11835-1-git-send-email-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Message-Id: <20150929075845.3F224140FA5@smtp.codeaurora.org> (sfid-20150929_095849_025351_19D1BB16)
Date: Tue, 29 Sep 2015 07:58:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> brcmfmac uses atomic_or() and other atomic_* functions, but does not
> include linux/atomic.h. This file gets included by some other header
> file so this normally does not cause problems.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
