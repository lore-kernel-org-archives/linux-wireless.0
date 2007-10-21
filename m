Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:50241 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXJUBj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 21:39:26 -0400
Date: Sun, 21 Oct 2007 01:20:30 +0000
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
Subject: [PATCH 0/2] ath5k: Further cleanups inside base.c
Message-ID: <20071021012030.GA5817@localhost.domain.invalid> (sfid-20071021_023929_249476_496FBD63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few more cleanups for base.c before i submit the rest of my fixes...

Q: Should we get rid of syctl stuff ? I mean user can only change 
calibration interval (which is something tricky for users to play with) 
and debug flags. Does anyone use this ? i mean we can put printks wherever
we want, there's no need for this stuff IMHO (it comes from madwifi).

