Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38488 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbbGUPCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:02:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: set wiphy's addresses to provide valid MACs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1436454428-24077-1-git-send-email-zajec5@gmail.com>
To: Rafa? Mi?ecki <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Message-Id: <20150721150246.266FE141AEE@smtp.codeaurora.org> (sfid-20150721_170249_714831_C6542F6F)
Date: Tue, 21 Jul 2015 15:02:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Broadcom's firmware requires every BSS to use MAC address with unique
> last few bits. The amount of bits may depend on a particular firmware,
> it was verified to be 2 for BCM43602 one.
> If this condition won't be fulfilled firmware will reject such MAC:
> brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
> 
> We don't want to simply set addr_mask as it would also disallow using
> locally administrated bit. Instead let's build a list of addresses
> manually enabling 0x2 bit for extra interfaces.
> 
> Signed-off-by: Rafa? Mi?ecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
