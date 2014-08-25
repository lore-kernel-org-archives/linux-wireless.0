Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:51970 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaHYIAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:00:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
	zajec5@gmail.com
Subject: Re: [RFC 5/7] bcma: get IRQ numbers from dt
Date: Mon, 25 Aug 2014 10:00:01 +0200
Message-ID: <1408960991.IQOFBLWbOW@wuerfel> (sfid-20140825_100028_049250_61AD115E)
In-Reply-To: <1408915485-8078-7-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de> <1408915485-8078-7-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 August 2014 23:24:43 Hauke Mehrtens wrote:
> It is not possible to auto detect the irq numbers used by the cores on
> an arm SoC. If bcma was registered with device tree it will search for
> some device tree nodes with the irq number and add it to the core
> configuration.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
