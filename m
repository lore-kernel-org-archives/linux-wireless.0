Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFFGnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:43:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Andy Lutomirski <luto@amacapital.net>,
	Michal Kazior <michal.kazior@tieto.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
	<CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
	<CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com>
	<87r433ps7w.fsf@kamboji.qca.qualcomm.com>
	<53909602.5010703@candelatech.com>
Date: Fri, 6 Jun 2014 09:39:51 +0300
In-Reply-To: <53909602.5010703@candelatech.com> (Ben Greear's message of "Thu,
	5 Jun 2014 09:08:34 -0700")
Message-ID: <87oay6mthk.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_084312_654705_9BD06E2C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>> Michal already did. The error means that for some reason the
>> calibaration data was not found from OTP. OTP is the storage area where
>> the calibration data is normally stored within QCA9880.
>
> I fought this with .387 firmware and WLE900VX NICs.  If it's a common
> problem with more than a single NIC (ie, not just a bad piece of
> hardware), then one could load my firmware and my ath10k patches.

That's XB143, right? I think that's different as firmware started to
support XB143 only starting from 10.1.467.

-- 
Kalle Valo
