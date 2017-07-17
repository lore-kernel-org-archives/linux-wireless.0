Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:55644 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdGQQQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:16:44 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: PATCH: brcmfmac driver cleanup
Date: Mon, 17 Jul 2017 17:16:08 +0100
Message-Id: <20170717161637.4652-1-ian@mnementh.co.uk> (sfid-20170717_181648_908664_7BDACA96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is a respin of my patchset from yesterday. I consider this finished and
have signed it off. It's improved since yesterday, with better names chosen for
a few functions.

It's all clean-up with the exception of the patch titled HACK, which I dont have enough information to address.

If someone at Broadcom wants to give me some documentation, it would help considerably.

This has been tested on 4.12 and 4.12.2 on a per-patch basis.

I cannot fully test on 4.13-rc1 as the driver is broken in mainline and no longer works on my hardware (43430a1).

-Ian
