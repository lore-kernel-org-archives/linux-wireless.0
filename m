Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:10238 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaG3Pbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 11:31:39 -0400
Message-ID: <53D90FCA.9030603@broadcom.com> (sfid-20140730_173142_753164_CFA830C4)
Date: Wed, 30 Jul 2014 17:31:22 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?ANDR=C9_SI?= <andre_cte2010@hotmail.com>
CC: "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bug Driver Broadcom
References: <BLU180-W14370D921EDB121FE8EC149DF90@phx.gbl> <BLU180-W146AAC9DB0BDA5C16DED8B9DF90@phx.gbl>
In-Reply-To: <BLU180-W146AAC9DB0BDA5C16DED8B9DF90@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/14 16:59, ANDRÉ SI wrote:
>
> Good Day,
> I have a laptop with a Broadcom wireless card:
> 02:00.0 Network controller: Broadcom Corporation BCM43225 802.11b/g/n
> (rev 01)
> and PCI ID 14e4:4357.
> I have Linux installed and the chipset just don't identifies wireless
> network in channel 12 and 13,
> I live in Brazil, wireless networks at channel 12 and 13 are permitted
> here, how can i solve this problem ?
> I have searched solutions on the internet but none work.

As far as I know the brcmsmac driver has a custom regulatory domain, 
which allows those channels although it is not allowed to initiate 
radiation on them. Without any kernel log I can only guess. Can you 
provide a kernel log and output of 'iw list' command?

Regards,
Arend
