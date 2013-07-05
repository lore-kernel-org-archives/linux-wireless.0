Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47903 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3GEPuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 11:50:02 -0400
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: Passing a custom MAC to ath6kl
References: <51D6E484.9060000@digi.com>
Date: Fri, 5 Jul 2013 18:49:56 +0300
In-Reply-To: <51D6E484.9060000@digi.com> (Hector Palacios's message of "Fri, 5
	Jul 2013 17:21:40 +0200")
Message-ID: <87vc4pf1ln.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_175007_928015_05D2A7C4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hector Palacios <hector.palacios@digi.com> writes:

> Is there a way to pass a custom MAC address to the ath6kl upstream driver?

Not right now. It has been a common feature request so I'm hoping
someone will implement it soon.

> In the ISC version of the driver, a softmac.c file is provided that
> reads a MAC from a file if a module parameter softmac_enable=1 is
> passed. Is there any reason why this has not made it upstream?

Providing mac address through a file is too ugly for upstream. We need
to implement it properly using the proper interface.

-- 
Kalle Valo
