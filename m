Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:35780 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbbA3OkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 09:40:16 -0500
Message-ID: <54CB97CC.2050001@broadcom.com> (sfid-20150130_154021_697022_4DDE0598)
Date: Fri, 30 Jan 2015 15:40:12 +0100
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
>
> and the network interface is never created.
>
> I'm running kernel 3.18.4, my brcmfmac43241b4-sdio.bin is identical to
> the one in the linux-firmware repository, and I have attached the
> brcmfmac43241b4-sdio.txt that I have extracted from the EFI variables.

When you say your firmware is identical what does that mean. Did you do 
a diff? Can you do 'hexdump -C brcmfmac43241b4-sdio.bin | tail -30'? I 
will be getting a laptop with 43241 integrated soonish (monday?). 
Hopefully it has same chip revision.

Regards,
Arend
> Any help would be appreciated.
>
> Sébastien

