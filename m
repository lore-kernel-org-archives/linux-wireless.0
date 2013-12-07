Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37689 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3LGThF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 14:37:05 -0500
Received: by mail-oa0-f51.google.com with SMTP id i7so2295819oag.10
        for <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 11:37:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A313FF.2000301@gmail.com>
References: <52A313FF.2000301@gmail.com>
Date: Sat, 7 Dec 2013 21:37:05 +0200
Message-ID: <CANUX_P03pOAijbPwCUJ_LnkZBaxMi2JCsEM+fL6hw44=ShYhwg@mail.gmail.com> (sfid-20131207_203710_532520_D68783C6)
Subject: Re: iwlwifi error when activating network-manager hotspot function
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?ISO-8859-1?Q?Torquil_Macdonald_S=F8rensen?= <torquil@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> When activating the Hotspot function of Network Manager, I get this
> message in the dmesg output:
>
> [  103.801354] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [  103.808386] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [  103.908937] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  103.973502] ------------[ cut here ]------------
> [  103.973530] WARNING: CPU: 0 PID: 4144 at
> /build/linux-DpqWmm/linux-3.11.10/drivers/net/wireless/iwlwifi/dvm/tx.c:456
> iwlagn_tx_skb+0xb6c/0xb80 [iwldvm]()

This should be fixed by f6b129527ca15bae29ffb9417ddaa1c9d99ffc5d.
I should probably have CCed it to stable.
