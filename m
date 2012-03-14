Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44677 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030724Ab2CNTvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 15:51:45 -0400
Message-ID: <4F60F6CF.1010007@openwrt.org> (sfid-20120314_205150_644963_D06D7B9F)
Date: Wed, 14 Mar 2012 20:51:43 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
	linux-mips@linux-mips.org, ralf@linux-mips.org, m@bues.ch,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH v4 7/7] USB: use generic platform driver on ath79
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de> <1331597093-425-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1331597093-425-8-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.03.13. 1:04 keltezéssel, Hauke Mehrtens írta:
> The ath79 usb driver doesn't do anything special and is now converted
> to the generic ehci and ohci driver.
> This was tested on a TP-Link TL-WR1043ND (AR9132)
> 
> CC: Gabor Juhos <juhosg@openwrt.org>
> CC: Imre Kaloz <kaloz@openwrt.org>
> CC: linux-mips@linux-mips.org
> CC: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Gabor Juhos <juhosg@openwrt.org>
