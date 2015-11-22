Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34096 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbKVRaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 12:30:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/27] wireless drivers vendor directories
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
Date: Sun, 22 Nov 2015 19:30:12 +0200
In-Reply-To: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org> (Kalle
	Valo's message of "Wed, 18 Nov 2015 16:45:39 +0200")
Message-ID: <87h9kerlgb.fsf@kamboji.qca.qualcomm.com> (sfid-20151122_183119_745161_30F17A0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Hi,
>
> I started to reorganise drivers/net/wireless directory and follow what
> drivers/net/ethernet has. The major change is that new vendor
> directories are created and most of the drivers are now under those
> vendor directories:
>
> admtek/
> ath/
> atmel/
> broadcom/
> cisco/
> intel/
> intersil/
> marvell/
> mediatek/
> ralink/
> realtek/
> rsi/
> st/
> ti/
> zydas/
>

[...]

> Kalle Valo (27):
>   adm80211: move under admtek vendor directory
>   airo: move under cisco vendor directory
>   atmel: move under atmel vendor directory
>   b43: move under broadcom vendor directory
>   b43legacy: move under broadcom vendor directory
>   brcm80211: move under broadcom vendor directory
>   cw1200: move under st vendor directory
>   ipw2x00: move under intel vendor directory
>   iwlegacy: move under intel directory
>   iwlwifi: move under intel vendor directory
>   libertas: move under marvell vendor directory
>   libertas_tf: move under marvell vendor directory
>   mwifiex: move under marvell vendor directory
>   mwl8k: move under marvell vendor directory
>   zd1201: move under zydas vendor directory
>   zd1211rw: move under zydas vendor directory
>   hostap: move under intersil vendor directory
>   p54: move under intersil vendor directory
>   orinoco: move under intersil vendor directory
>   prism54: move under intersil vendor directory
>   realtek: create separate Kconfig file
>   rsi: add vendor Kconfig entry
>   rt2x00: move under ralink vendor directory
>   mediatek: unify Kconfig with other vendors
>   ti: unify Kconfig with other vendors
>   ath: unify Kconfig with other vendors
>   mac80211_hwsim: move Kconfig entry for sorting alphabetically

Applied to wireless-drivers-next.git.

-- 
Kalle Valo
