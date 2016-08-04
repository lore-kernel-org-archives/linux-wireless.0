Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56510 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbcHDGYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 02:24:53 -0400
Date: Thu, 4 Aug 2016 08:24:40 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] ath9k: fix GPIO mask for AR9462 and AR9565
Message-ID: <20160804082440.288dcba6@mir> (sfid-20160804_082458_160438_B7C62088)
In-Reply-To: <1470288583349.11756@qti.qualcomm.com>
References: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
	<20160717230519.46e3a661@mir>
	<87r3a6556p.fsf@qca.qualcomm.com>
	<1470288583349.11756@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2016-08-04, Pan, Miaoqing wrote:
> Sorry, try the patch.  AR5416 will invoke ath9k_hw_gpio_get() before gpio  initialized correctly.
> 
> Thanks,
> Miaoqing

Thanks a lot, the patch appears to work. Feel free to add

	Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

and please also send it to stable-4.7 (confirmed working).

	Cc: stable-4.7+ <stable@vger.kernel.org> #4.7+

Regards
	Stefan Lippers-Hollmann
