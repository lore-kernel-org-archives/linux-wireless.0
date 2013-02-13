Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761077Ab3BMXQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:16:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com
Subject: [PATCH 0/3] VHT regulatory
Date: Thu, 14 Feb 2013 00:16:01 +0100
Message-Id: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_001622_374083_BE3F392D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses the basic requirements for checking VHT
channel regulatory -- drivers can disable if they want,
the world roaming domain includes 80 MHz (*) and we now 
tell userspace what to expect.

johannes

(*) It's not entirely clear to me why world roaming excludes
    UNII-2? The comment says because of DFS, but what's the
    deal with that -- if there's an AP (DFS owner) we should
    be able to connect anyway??
