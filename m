Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIU0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 16:26:12 -0400
Received: by eeit10 with SMTP id t10so4461869eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 13:26:11 -0700 (PDT)
Message-ID: <4FFB3E60.9080001@gmail.com> (sfid-20120709_222616_758581_29FE2C67)
Date: Mon, 09 Jul 2012 22:26:08 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: thomas@net.t-labs.tu-berlin.de, x-alina@gmx.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
References: <4FFB2E78.9090402@gmail.com> <4FFB3469.4000003@openwrt.org>
In-Reply-To: <4FFB3469.4000003@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 09:43 PM, Felix Fietkau wrote:
> On 2012-07-09 9:18 PM, Xose Vazquez Perez wrote:

>> candidates:
>>
>> ath6kl
>> brcmfmac
>> iwmc3200wifi
>> mwifiex
>> rndis_wlan

> No. (fullmac, thus unaffected by the change)

orinoco is also fullmac.

>> libertas_tf
>> rtlwifi
>> wl1251
>> wl12xx

> Yes, those indeed look like they need to be added.

adm8211 at76c50x-usb mac80211_hwsim ??
