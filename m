Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51303 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3KLIBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 03:01:15 -0500
From: Kalle Valo <kvalo@adurom.com>
To: shankar swaminathan <shankswa@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] hooking all 802.11 packets to user space without conversion
References: <CADNhdGHGnHDYdum79cY89kV4LtpiGugMc84Mc_4bNmCuOWrn5g@mail.gmail.com>
Date: Tue, 12 Nov 2013 10:01:14 +0200
In-Reply-To: <CADNhdGHGnHDYdum79cY89kV4LtpiGugMc84Mc_4bNmCuOWrn5g@mail.gmail.com>
	(shankar swaminathan's message of "Tue, 12 Nov 2013 11:58:41 +0530")
Message-ID: <87d2m6rqut.fsf@purkki.adurom.net> (sfid-20131112_090123_977500_02FE925A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

shankar swaminathan <shankswa@gmail.com> writes:

> I would like to know if 802.11 packets could be hooked from the mac80211
> module to the user space.
>
> Basically, I run a module that needs the 802.11 pkts without converting
> them to 802.3.
>
> I am able to register for MLME pkts but not sure whether I can register for
> data pkts and get them to user space.

Have you tried adding a monitor interface and taking packets from that?

-- 
Kalle Valo
