Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536AbXGFL6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 07:58:53 -0400
Subject: Please pull from 'upstream-fixes' branch of libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Jul 2007 08:03:11 -0400
Message-Id: <1183723391.15222.8.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit e753a790e441194b2f58b10d5580e5bc52d4e03a:
  Dan Williams (1):
        libertas: remove private ioctls

are found in the git repository at:

  git://git.infradead.org/libertas-2.6

Dan Williams (1):
      libertas: fix disabling WPA

 drivers/net/wireless/libertas/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 13f6528..4a8f5dc 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -240,7 +240,7 @@ static int wlan_cmd_802_11_enable_rsn(wlan_private * priv,
 		if (*enable)
 			penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
 		else
-			penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
+			penableRSN->enable = cpu_to_le16(cmd_disable_rsn);
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);


