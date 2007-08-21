Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbXHUQWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:22:32 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1INWUS-0008Hi-0f
	for linux-wireless@vger.kernel.org; Tue, 21 Aug 2007 17:22:18 +0100
Message-Id: <20070821161845.165557000@sipsolutions.net>
Date: Tue, 21 Aug 2007 18:18:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] the filter stuff again
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Repost of my filtering patches slightly bug-fixed. This
works great for me (in that I don't see beacons from
other BSSes etc), but we don't seem to have reached
concensus yet whether we want to do it this way.

johannes

