Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45891 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755481AbeDYQZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 12:25:49 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 2/2] usb: typec: fix formatting errors that cause build breakage
Date: Wed, 25 Apr 2018 12:25:40 -0400
Message-Id: <20180425162540.11574-2-andresx7@gmail.com> (sfid-20180425_182628_468856_132C2DF2)
In-Reply-To: <20180425162540.11574-1-andresx7@gmail.com>
References: <20180425152617.GA5058@kroah.com>
 <20180425162540.11574-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ASCII art illustration should be marked as a preformatted text
block. Otherwise the build will fail when attempting to parse it.

Fixes: bdecb33af34f ( "usb: typec: API for controlling USB ..." )
Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---
 Documentation/driver-api/usb/typec.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/usb/typec.rst b/Documentation/driver-api/usb/typec.rst
index feb31946490b..48ff58095f11 100644
--- a/Documentation/driver-api/usb/typec.rst
+++ b/Documentation/driver-api/usb/typec.rst
@@ -210,7 +210,7 @@ If the connector is dual-role capable, there may also be a switch for the data
 role. USB Type-C Connector Class does not supply separate API for them. The
 port drivers can use USB Role Class API with those.
 
-Illustration of the muxes behind a connector that supports an alternate mode:
+Illustration of the muxes behind a connector that supports an alternate mode::
 
                      ------------------------
                      |       Connector      |
-- 
2.14.1
