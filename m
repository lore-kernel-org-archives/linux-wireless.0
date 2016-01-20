Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:54604 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbcATU6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 15:58:20 -0500
To: arend@broadcom.com, linux-wireless@vger.kernel.org,
	meuleman@broadcom.com
From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: brcmfmac: brcmf_sdio_drivestrengthinit missing for bcm4324
Message-ID: <569FF4E9.6060303@hauke-m.de> (sfid-20160120_215823_981159_C5F40EA3)
Date: Wed, 20 Jan 2016 21:58:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw this line on some Sony laptop using a bcm4324 for wifi:

brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init done
for chip 4324 rev 5 pmurev 17

This was with an older kernel version, but the code does not look like
it is fixed now. Wifi still worked even with this warning.

This was a device from the normal German retail market shipped with some
Windows version, but I do not have access to this device any more.

Hauke
