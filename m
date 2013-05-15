Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:46727 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab3EOQeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 12:34:10 -0400
Date: Wed, 15 May 2013 18:34:03 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
Message-ID: <20130515163403.GA14955@zenon.in.qult.net> (sfid-20130515_183417_380413_B7B851F8)
References: <20130515134258.GA9033@zenon.in.qult.net>
 <87a9nwpaaf.fsf@kamboji.qca.qualcomm.com>
 <CAFSJ42bDB+c0=eRmBYZBaQnZ4-h2Jm_MWZbfSEhUELb9y0Qv_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFSJ42bDB+c0=eRmBYZBaQnZ4-h2Jm_MWZbfSEhUELb9y0Qv_Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 15, 2013 at 06:11:49PM +0200, thus spake Eugene Krasnikov:
> there is a function in driver "ath9k_htc_reset"
> http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath9k/htc_drv_main.c#L189
> but not sure that is what you are looking for.

>From the issue report about watchdog problems, I gather that the device is
supposed to be prepared for reception of the firmware code from the driver.
This normally happens when the device boots up and passes the first stage of
the bootloader.  I suppose (I'm really totally guessing) that the driver
somehow doesn't do something to prepare the device for firmware upload if the
device is already past stage 2.

I would love to have the UART pins connected to some terminal, but I don't
have the soldering tools for such small-scale work...

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.
