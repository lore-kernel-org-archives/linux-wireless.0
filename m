Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33834 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbdGZU0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:26:09 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: Patch v4: Clean up brcmfmac driver
Date: Wed, 26 Jul 2017 21:25:23 +0100
Message-Id: <20170726202557.15632-1-ian@mnementh.co.uk> (sfid-20170726_222619_922459_6D54A866)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

Here's a v4 of the cleanup patchset - checkpatch clean(er - I have purposely
left some warnings unaddressed).

I also dropped an accidental adjustment of a debug macro from v3.

-Ian
