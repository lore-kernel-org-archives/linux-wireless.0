Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47562 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab3LGTnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 14:43:25 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so2290900oag.30
        for <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 11:43:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P03pOAijbPwCUJ_LnkZBaxMi2JCsEM+fL6hw44=ShYhwg@mail.gmail.com>
References: <52A313FF.2000301@gmail.com>
	<CANUX_P03pOAijbPwCUJ_LnkZBaxMi2JCsEM+fL6hw44=ShYhwg@mail.gmail.com>
Date: Sat, 7 Dec 2013 21:43:24 +0200
Message-ID: <CANUX_P17Ky2Rr3H3NSmnLS09Ez7-a=AR0e61VhEY0qna_mGgKg@mail.gmail.com> (sfid-20131207_204333_884941_2DD247F3)
Subject: Re: iwlwifi error when activating network-manager hotspot function
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?ISO-8859-1?Q?Torquil_Macdonald_S=F8rensen?= <torquil@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 7, 2013 at 9:37 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> When activating the Hotspot function of Network Manager, I get this
>> message in the dmesg output:
>>
>> [  103.801354] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>> [  103.808386] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
>> [  103.908937] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  103.973502] ------------[ cut here ]------------
>> [  103.973530] WARNING: CPU: 0 PID: 4144 at
>> /build/linux-DpqWmm/linux-3.11.10/drivers/net/wireless/iwlwifi/dvm/tx.c:456
>> iwlagn_tx_skb+0xb6c/0xb80 [iwldvm]()
>
> This should be fixed by f6b129527ca15bae29ffb9417ddaa1c9d99ffc5d.
> I should probably have CCed it to stable.

Just did.
