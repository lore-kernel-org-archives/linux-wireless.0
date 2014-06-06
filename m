Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44032 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaFFQFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 12:05:23 -0400
Message-ID: <5391E6C2.7030602@candelatech.com> (sfid-20140606_180526_754509_EDCC10FD)
Date: Fri, 06 Jun 2014 09:05:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Andy Lutomirski <luto@amacapital.net>,
	Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com> <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com> <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com> <87r433ps7w.fsf@kamboji.qca.qualcomm.com> <53909602.5010703@candelatech.com> <87oay6mthk.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oay6mthk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 11:39 PM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>>> Michal already did. The error means that for some reason the
>>> calibaration data was not found from OTP. OTP is the storage area where
>>> the calibration data is normally stored within QCA9880.
>>
>> I fought this with .387 firmware and WLE900VX NICs.  If it's a common
>> problem with more than a single NIC (ie, not just a bad piece of
>> hardware), then one could load my firmware and my ath10k patches.
> 
> That's XB143, right? I think that's different as firmware started to
> support XB143 only starting from 10.1.467.


Yes.  My point is that I have the ability to get debug info out of
of the otp in my modified firmware, so it is possible to debug why
the otp is failing in the first place, and possibly fix otp to work
with that NIC.

I'll start begging to get my CT firmware support in upstream kernels
as soon as we get the firmware-crash stuff ironed out :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

