Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54487 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3KHRfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 12:35:00 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so651459wgh.35
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 09:34:59 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH 0/3] pull request: wcn36xx 2013-11-08
Date: Fri,  8 Nov 2013 17:34:36 +0000
Message-Id: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com> (sfid-20131108_183505_421552_FB1A1621)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is a bunch of patches for wcn36xx driver on top of current wireless-next.
The format is just a list of patches but not a git pull request. If you prefere
to have them as a git pull link please let me know. Also please let me know if
there is any problem.

Dan Carpenter (1):
  wcn36xx: missing unlocks on error paths

Eugene Krasnikov (1):
  wcn36xx: Fix logging macro with unnecessary semicolon

Wei Yongjun (1):
  Add the missing unlock before return from function
    wcn36xx_smd_update_proberesp_tmpl() in the error handling case.

 drivers/net/wireless/ath/wcn36xx/smd.c     | 9 ++++++---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.8.3.2

