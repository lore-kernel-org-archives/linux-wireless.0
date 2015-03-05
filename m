Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38052 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbbCEL5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 06:57:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: bcma: Kconfig: Let it depend on PCI
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
To: Chen Gang <xili_gchen_5257@hotmail.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <20150305115733.D417D141E3C@smtp.codeaurora.org> (sfid-20150305_125815_193305_AD832079)
Date: Thu,  5 Mar 2015 11:57:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> bcma also needs PCI, just like IOMEM and DMA, so let it depend on PCI,
> or will cause building break for allmodconfig under c6x:
> 
>     CC [M]  drivers/bcma/driver_pcie2.o
>   drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>   drivers/bcma/driver_pcie2.c:196:8: error: implicit declaration of function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>     err = pcie_set_readrq(dev, pcie2->reqsize);
>           ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
