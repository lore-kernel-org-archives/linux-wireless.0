Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47902 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CFRXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 12:23:44 -0500
Received: by wyg36 with SMTP id 36so3553649wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 09:23:43 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 0/2] wl1251: minor PS improvements
Date: Sun,  6 Mar 2011 19:23:35 +0200
Message-Id: <1299432217-32139-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did these patches a while ago but never got around sending them.
I know it's a bit late for .39 and don't mind if they go for .40
(or not at all if they are bad ;) ).

Grazvydas Ignotas (2):
  wl1251: remove wl1251_ps_set_elp function
  wl1251: fix elp_work race condition

 drivers/net/wireless/wl1251/ps.c |   41 +++++--------------------------------
 1 files changed, 6 insertions(+), 35 deletions(-)

