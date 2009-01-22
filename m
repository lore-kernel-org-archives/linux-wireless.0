Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4882 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZAVNog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/6] ath5k: various misc fixes
Date: Thu, 22 Jan 2009 08:44:15 -0500
Message-Id: <1232631861-6028-1-git-send-email-me@bobcopeland.com> (sfid-20090122_144443_207277_51B96C99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, here are some various updates for ath5k, some minor fixes, it's 
probably all 2.6.30 material.

- patch 1 fixes a locking bug, but for consistency, not to fix any reported
  issue
- patches 2 and 4 are cleanups
- patch 3 makes reset() more closely match the HAL, it may help with reset
  errors but really is unlikely to fix any problem
- patches 5 and 6 add missing support for some rate flags that have been
  ignored by ath5k since forever

