Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:24125 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbCTMhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:37:45 -0400
Message-ID: <550C148D.6080000@broadcom.com> (sfid-20150320_133748_438577_D67688A8)
Date: Fri, 20 Mar 2015 13:37:33 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcm: firmware drop for brcmfmac driver
References: <1426854911-30796-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1426854911-30796-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/15 13:35, Arend van Spriel wrote:
> This series adds firmware files for a number of "new" devices.
> Admittedly there was bit of backlog. For BCM4354 SDIO this
> series has firmware upgrade.
>
> This series does apply to the master branch of the linux-firmware
> repo on top of commit f10b97abdab2 ("radeon: Update Kaveri MEC
> firmware to #396").

Aborted this series during git-sendemail realizing something is missing.

Sorry for the noise.

Regards,
Arend

> Arend van Spriel (7):
>    brcm: add firmware for BCM43242 USB device
>    brcm: add firmware for BCM4356 PCIe device
>    brcm: add firmware files for BCM43602 PCIe device
>    brcm: add firmware for BCM43455 SDIO device
>    brcm: add firmware for BCM4339 SDIO device
>    brcm: add firmware for BCM43340/1 SDIO devices
>    brcm: upgrade firmware for BCM4354 SDIO device
>
>   WHENCE                         |   7 +++++++
>   brcm/brcmfmac43242a.bin        | Bin 0 ->  479232 bytes
>   brcm/brcmfmac43340-sdio.bin    | Bin 0 ->  397378 bytes
>   brcm/brcmfmac4339-sdio.bin     | Bin 0 ->  569291 bytes
>   brcm/brcmfmac43455-sdio.bin    | Bin 0 ->  488193 bytes
>   brcm/brcmfmac4354-sdio.bin     | Bin 507752 ->  591837 bytes
>   brcm/brcmfmac4356-pcie.bin     | Bin 0 ->  593956 bytes
>   brcm/brcmfmac43602-pcie.ap.bin | Bin 0 ->  588940 bytes
>   brcm/brcmfmac43602-pcie.bin    | Bin 0 ->  590544 bytes
>   9 files changed, 7 insertions(+)
>   create mode 100644 brcm/brcmfmac43242a.bin
>   create mode 100644 brcm/brcmfmac43340-sdio.bin
>   create mode 100644 brcm/brcmfmac4339-sdio.bin
>   create mode 100644 brcm/brcmfmac43455-sdio.bin
>   rewrite brcm/brcmfmac4354-sdio.bin (81%)
>   create mode 100644 brcm/brcmfmac4356-pcie.bin
>   create mode 100644 brcm/brcmfmac43602-pcie.ap.bin
>   create mode 100644 brcm/brcmfmac43602-pcie.bin
>

