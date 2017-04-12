Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33406 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755498AbdDLRnR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 13:43:17 -0400
Received: by mail-pg0-f49.google.com with SMTP id x125so18146696pgb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 10:43:17 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] MAINTAINERS: drop akarwar from mwifiex
Date: Wed, 12 Apr 2017 10:42:55 -0700
Message-Id: <20170412174255.15021-1-briannorris@chromium.org> (sfid-20170412_194533_597645_75FC3D97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

His email is bouncing, and I expect he's not doing this work any more.

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Ganapathi Bhat <gbhat@marvell.com>
Cc: Xinming Hu <huxm@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Or alternatively, we can update his email address. I just don't want to keep
seeing bounced emails :)

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 078c38217daa..5e316efbfe31 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7844,7 +7844,6 @@ S:	Maintained
 F:	drivers/net/ethernet/marvell/mvneta.*
 
 MARVELL MWIFIEX WIRELESS DRIVER
-M:	Amitkumar Karwar <akarwar@marvell.com>
 M:	Nishant Sarmukadam <nishants@marvell.com>
 M:	Ganapathi Bhat <gbhat@marvell.com>
 M:	Xinming Hu <huxm@marvell.com>
-- 
2.12.2.715.g7642488e1d-goog
