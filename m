Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59270 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbcFPPYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:24:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: drop unused pm_block vif attribute
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465247047-19412-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160616152405.42FED61372@smtp.codeaurora.org> (sfid-20160616_172430_870417_CAC85BC3)
Date: Thu, 16 Jun 2016 15:24:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> This attribute was added 3 years ago by
> commit 3eacf866559c ("brcmfmac: introduce brcmf_cfg80211_vif structure")
> but it remains unused since then. It seems we can safely drop it.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

26072330df2e brcmfmac: drop unused pm_block vif attribute

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9159139/

