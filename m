Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16841 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaGUJSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 05:18:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mike Reardon <mike.pc.reardon@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: Fwd: How to set it up, when not working
References: <CABAoMoBoBqPP9K_89E7odX8vTWkFSU_ahJ0FGjnBW3wiVz=dEQ@mail.gmail.com>
	<CABAoMoChE7jceUs=im6Vo6K2YMYSP9X4+bmj=AbqnMcrTqDgQw@mail.gmail.com>
Date: Mon, 21 Jul 2014 12:18:27 +0300
In-Reply-To: <CABAoMoChE7jceUs=im6Vo6K2YMYSP9X4+bmj=AbqnMcrTqDgQw@mail.gmail.com>
	(Mike Reardon's message of "Sat, 19 Jul 2014 15:23:21 -0400")
Message-ID: <8738dvysrg.fsf@kamboji.qca.qualcomm.com> (sfid-20140721_111836_857216_917BACEC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mike Reardon <mike.pc.reardon@gmail.com> writes:

> Recently purchased Dell Venue 11 Pro 7130
>
> Proceeded to set it up dual boot with live version of Ubuntu, then Fedora and
> Suse but not one recognized wifi.
>
> I have two with this unit, the first not connecting follows:
>
> * Dell Wireless 1537 802.11 a/g/n Adapter
> which I understand is Qualcom Atheros 3.7.2.45422  2013-10-17
> AR6004
>
> * Dell Wireless 5808 Gobi 4G LTE Mobile Broadband Card
>
> Further research established the former with 'ath6kl' is the FullMAC wireless
> driver for Atheros AR600x family of chips, for example AR6003, AR6004 and
> AR6005. And it is available since kernel 3.2
>
> It works in Windows 8.1, yet it is not working with Linux

I have understood it has a variant of ar6004 hw3.0 chip and just last
week patches supporting that went into wireless-testing tree. You also
need to add the new SDIO id to ath6kl, more info here:

https://bugzilla.kernel.org/show_bug.cgi?id=67921

-- 
Kalle Valo
