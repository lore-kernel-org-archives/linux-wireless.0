Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37744 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1HOTAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 15:00:00 -0400
Message-ID: <4E496CA7.7000604@hauke-m.de> (sfid-20110815_210005_009194_0B2212F0)
Date: Mon, 15 Aug 2011 20:59:51 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Lin Tony-B19295 <B19295@freescale.com>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kvalo@qca.qualcomm.com, rmani@qca.qualcomm.com
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de> <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2011 07:06 AM, Lin Tony-B19295 wrote:
> Where can I get corresponding firmware?
> 
> tony
> 
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Hauke Mehrtens
>> Sent: Thursday, August 11, 2011 6:59 PM
>> To: mcgrof@gmail.com; lrodriguez@atheros.com
>> Cc: linux-wireless@vger.kernel.org; Hauke Mehrtens
>> Subject: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
>>
>> ath6kl is now in the kernel main area and not in staging any more.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  Makefile                                |    1 -
>>  config.mk                               |   15 +++------
>>  patches/01-netdev.patch                 |   17 +++++++++--
>>  patches/34-backport-bin_attribute.patch |   47 -------------------------

Hi tony,

there is a firmware for these devices in the linux-firmware git [0], but
I do not know if it still works with this driver.

Probably some of the ath6kl developer could help you more than me.

Hauke

[0]:
https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary
