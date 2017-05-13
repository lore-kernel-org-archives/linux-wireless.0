Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbdEMMTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 08:19:30 -0400
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Subject: New brcmfmac errors in 4.12: brcmf_sdio_rxglom: sublen ... not
 multiple of 8
Message-ID: <e8055bc7-eaf4-1ab6-31d1-130d83485980@redhat.com> (sfid-20170513_141939_165453_92874B5C)
Date: Sat, 13 May 2017 14:19:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just rebased my personal kernel tree to what will soon be 4.12-rc1
and I'm getting my dmesg log filled with the following errors:

[   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
[   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
[   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8

Other brcmfmac dmesg messages:

[   16.020013] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul 17 2013 07:36:07 version 6.10.197.71 (r412987) FWID 01-882d2634

This is on a Asus T100TA which uses a 43241b1

Regards,

Hans
