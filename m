Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60977 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1KQSpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:45:03 -0500
Message-ID: <4EC5562B.4050001@openwrt.org> (sfid-20111117_194508_060378_FE88B68B)
Date: Thu, 17 Nov 2011 19:44:59 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Daniel Kuehn <daniel@kuehn.se>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] Seeing as alot of ath9k devices is PCI/PCIe or their
 mini equivalent it makes sense to set ATH9K_PCI to y by default
References: <20111109235757.79821a20@Artemis> <4EC524B1.2070200@openwrt.org> <20111117163947.1749dfb1@Artemis>
In-Reply-To: <20111117163947.1749dfb1@Artemis>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011.11.17. 16:39 keltezéssel, Daniel Kuehn írta:

> I agree with you there if it was removed before, maybe then only the help 
> section of ath9k should be changed to say that you have to enable either 
> PCI/PCIe or AHB support for it to work?

Yes, adding a comment there would make sense, although that does not prevent
to build ath9k without bus support.

-Gabor
