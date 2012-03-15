Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268Ab2COPxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 11:53:50 -0400
Message-Id: <20120315154133.312616639@sipsolutions.net> (sfid-20120315_165353_820977_9A0B3B77)
Date: Thu, 15 Mar 2012 16:41:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@chromium.org>
Subject: [RFC 0/3] set HT channel first
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We talked about this before a bit, and I've started
work on it. I'm not sure about the queue stop/flush
but it seems very strange to do it now. Rajkumar,
can you maybe look into this?

Paul, could you check this in the problem case you
were running into?

johannes

