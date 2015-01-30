Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ssl.serverraum.org ([88.198.40.39]:46495 "EHLO
	ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbA3Q2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 11:28:14 -0500
Message-ID: <54CBB118.5020806@m-labs.hk> (sfid-20150130_172818_197971_1AF9B275)
Date: Sat, 31 Jan 2015 00:28:08 +0800
From: Sebastien Bourdeauducq <sb@m-labs.hk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: "brcmfmac: brcmf_sdio_htclk: HT Avail timeout" on Thinkpad Tablet
 10
References: <54C88C7D.707@m-labs.hk> <54CB97CC.2050001@broadcom.com>
In-Reply-To: <54CB97CC.2050001@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 30, 2015 10:40 PM, Arend van Spriel wrote:
>> I'm running kernel 3.18.4, my brcmfmac43241b4-sdio.bin is identical to
>> the one in the linux-firmware repository, and I have attached the
>> brcmfmac43241b4-sdio.txt that I have extracted from the EFI variables.
>
> When you say your firmware is identical what does that mean.

It is exactly this file (diff reports same content):

https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/brcm/brcmfmac43241b4-sdio.bin

Sebastien
