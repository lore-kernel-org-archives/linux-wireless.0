Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:49689 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeEBSFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 14:05:40 -0400
Date: Wed, 2 May 2018 20:05:34 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>
Message-ID: <1350822038.83583.1525284334972@email.1und1.de> (sfid-20180502_200638_472354_05F7C2E0)
Subject: brcmfmac: Updating Broadcom/Cypress Wifi/BT firmware
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
i wanted to know, if there are any plans to update the Broadcom/Cypress firmware under:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

As BCM2835 maintainer i'm interested in the following files:

brcm/brcmfmac43430-sdio.bin
brcm/brcmfmac43455-sdio.bin
brcm/brcmfmac43430-sdio.txt
brcm/BCM43430A1.hcd

It would be nice to have those files in this repository, so kernelci could fetch it from there.

Best regards
Stefan
