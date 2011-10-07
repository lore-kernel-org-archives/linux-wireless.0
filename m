Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab1JGMEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:04:52 -0400
Message-Id: <20111007120122.982757001@sipsolutions.net> (sfid-20111007_140455_187825_7C2CC072)
Date: Fri, 07 Oct 2011 14:01:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211 radiotap TX cleanup
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches clean up/optimise the non-radiotap
TX path by moving all radiotap related parsing
right into monitor xmit.

johannes

