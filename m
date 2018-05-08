Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933383AbeEHSNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 14:13:11 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org,
        josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org,
        david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        cantabile.desu@gmail.com, ast@fb.com, hare@suse.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl,
        davem@davemloft.net, arve@android.com, tkjos@android.com,
        corbet@lwn.net, mchehab+samsung@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 12/13] Documentation: remove stale firmware API reference
Date: Tue,  8 May 2018 11:12:46 -0700
Message-Id: <20180508181247.19431-13-mcgrof@kernel.org> (sfid-20180508_201429_719071_3692D87D)
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It refers to a pending patch, but this was merged eons ago.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 Documentation/dell_rbu.txt | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.txt
index 0fdb6aa2704c..077fdc29a0d0 100644
--- a/Documentation/dell_rbu.txt
+++ b/Documentation/dell_rbu.txt
@@ -121,9 +121,6 @@ read back the image downloaded.
 
 .. note::
 
-   This driver requires a patch for firmware_class.c which has the modified
-   request_firmware_nowait function.
-
    Also after updating the BIOS image a user mode application needs to execute
    code which sends the BIOS update request to the BIOS. So on the next reboot
    the BIOS knows about the new image downloaded and it updates itself.
-- 
2.17.0
