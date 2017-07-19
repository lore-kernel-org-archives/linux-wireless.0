Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56100 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933711AbdGSTIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:08:36 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: PATCH v3 brcmfmac driver cleanup
Date: Wed, 19 Jul 2017 20:07:48 +0100
Message-Id: <20170719190822.10857-1-ian@mnementh.co.uk> (sfid-20170719_210846_638384_FF7087A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Please find the 3rd revision of my cleanup patchset for brcmfmac.

I've done some further cleanup and it now handles SDIO the ay the MMC subsystem
was designed to.

I've also taken the liberty of greatly reducing the amount of indirection
used thoughout the SDIO code, which I think has improved readability quite a
lot.

Hope this finds you all well.

-Ian
