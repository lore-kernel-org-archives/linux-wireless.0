Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58250 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3GKPHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:07:06 -0400
Message-ID: <51DECA02.6070706@candelatech.com> (sfid-20130711_170710_276976_1FA435D6)
Date: Thu, 11 Jul 2013 08:06:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] ath10k: Fix crash when using v1 hardware.
References: <1372804925-1701-1-git-send-email-greearb@candelatech.com> <51D35D58.5090507@candelatech.com> <87txk15te4.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87txk15te4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2013 02:37 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> Actually, I have no idea what type of hardware this is.  It was
>> suggested earlier to me that this AP had a v1 hardware in it, but
>> lspci shows this fairly unpromising thing, and the ath10k driver
>> appears to call 003c the V2 hardware....
>>
>> 05:00.0 Network controller: Atheros Communications Inc. Device 003c (rev ff) (prog-if ff)
>> 	!!! Unknown header type 7f
>> 	Kernel modules: ath10k_pci
>
> That unknown header type looks scary. I'm starting to suspect even more
> that you have a hw problem of some sort.

I tried two different NICS extracted from two different APs and the behaviour
is the same, so it is probably not just a manufacturing error.

Please note that I do NOT have v1 firmware, though from what I could tell,
this NIC was showing up as v2 hardware anyway...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

