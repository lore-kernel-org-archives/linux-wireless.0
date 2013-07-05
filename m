Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:15274 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757369Ab3GEP5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 11:57:09 -0400
Message-ID: <51D6EC90.40009@digi.com> (sfid-20130705_175713_469623_3DA2AEDC)
Date: Fri, 5 Jul 2013 17:56:00 +0200
From: Hector Palacios <hector.palacios@digi.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Passing a custom MAC to ath6kl
References: <51D6E484.9060000@digi.com> <87vc4pf1ln.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vc4pf1ln.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Kalle,

On 07/05/2013 05:49 PM, Kalle Valo wrote:
> Hector Palacios <hector.palacios@digi.com> writes:
>
>> Is there a way to pass a custom MAC address to the ath6kl upstream driver?
>
> Not right now. It has been a common feature request so I'm hoping
> someone will implement it soon.
>
>> In the ISC version of the driver, a softmac.c file is provided that
>> reads a MAC from a file if a module parameter softmac_enable=1 is
>> passed. Is there any reason why this has not made it upstream?
>
> Providing mac address through a file is too ugly for upstream. We need
> to implement it properly using the proper interface.

I totally agree. What would be the proper interface for that?

Best regards,
--
Hector Palacios
