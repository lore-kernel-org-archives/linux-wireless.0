Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:36353 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3AWPa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 10:30:28 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so3825428dak.5
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 07:30:28 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 23 Jan 2013 16:30:27 +0100
Message-ID: <CAHsu+b_yQn53EXUi71MRAeOrq2p+j+Ry0j6Ge5m3We0QcR698g@mail.gmail.com> (sfid-20130123_163032_943776_07E5F73D)
Subject: brcmfmac and 43362
From: Andre Heider <a.heider@gmail.com>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to add support for 43362 to brcmfmac, but I'm not sure
where to get the required settings for
drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c:brcmf_sdio_chip_recognition()
from.

Any hints?

Thanks in advance,
Andre
