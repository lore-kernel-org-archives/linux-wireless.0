Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40969 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab2GIVWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 17:22:16 -0400
Message-ID: <4FFB4B87.2030507@net.t-labs.tu-berlin.de> (sfid-20120709_232220_478362_8203BF52)
Date: Mon, 09 Jul 2012 23:22:15 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Felix Fietkau <nbd@openwrt.org>, x-alina@gmx.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
References: <4FFB2E78.9090402@gmail.com> <4FFB3469.4000003@openwrt.org> <4FFB3E60.9080001@gmail.com>
In-Reply-To: <4FFB3E60.9080001@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xose,

Thanks for your hint to really take all drivers into account.
I changed the following drivers tx-path to handle the new sts struct:
adm8211
at76c50x-usb
libertas_tf
rtlwifi
wl1251
wlcore

As soon as my last Broadcom patch is accepted,
my renewed sta-change patch goes on the list.

Greetings Thomas

Xose Vazquez Perez schrieb:

> On 07/09/2012 09:43 PM, Felix Fietkau wrote:
>> On 2012-07-09 9:18 PM, Xose Vazquez Perez wrote:
> 
>>> candidates:
>>>
>>> ath6kl
>>> brcmfmac
>>> iwmc3200wifi
>>> mwifiex
>>> rndis_wlan
> 
>> No. (fullmac, thus unaffected by the change)
> 
> orinoco is also fullmac.
> 
>>> libertas_tf
>>> rtlwifi
>>> wl1251
>>> wl12xx
> 
>> Yes, those indeed look like they need to be added.
> 
> adm8211 at76c50x-usb mac80211_hwsim ??

