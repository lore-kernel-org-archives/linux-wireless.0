Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52707 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbA2Tp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 14:45:59 -0500
Message-ID: <54CA8DE3.7050106@broadcom.com> (sfid-20150129_204602_590786_DDEB47F8)
Date: Thu, 29 Jan 2015 20:45:39 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?U8OpYmFzdGllbiBCb3VyZGVhdWR1Y3E=?= <sb@m-labs.hk>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: "brcmfmac: brcmf_sdio_htclk: HT Avail timeout" on Thinkpad Tablet
 10
References: <54C88C7D.707@m-labs.hk>
In-Reply-To: <54C88C7D.707@m-labs.hk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/15 08:15, Sébastien Bourdeauducq wrote:
> Hi,
>
> The Lenovo Thinkpad Tablet 10 is a complete disaster under Linux, and
> among many problems the SDIO brcmfmac wifi does not work.
>
> I get the following messages in the kernel log:
> brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init done
> for chip 4324 rev 6 pmurev 17
> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
> [repeated]

This usually means the firmware did not start properly.

> and the network interface is never created.
>
> I'm running kernel 3.18.4, my brcmfmac43241b4-sdio.bin is identical to
> the one in the linux-firmware repository, and I have attached the
> brcmfmac43241b4-sdio.txt that I have extracted from the EFI variables.

At first glance that looks fine to me. However, it is already late here 
so I will have a closer look tomorrow. If you can send a log with 
brcmfmac loaded with parameter 'debug=0x1416' that may give me some more 
clues.

Regards,
Arend

> Any help would be appreciated.
>
> Sébastien

