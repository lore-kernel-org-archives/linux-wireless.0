Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYDALtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:49:02 -0400
Message-Id: <20080331172258.541914000@sipsolutions.net> (sfid-20080401_124933_476004_F5FE2919)
Date: Mon, 31 Mar 2008 19:22:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/6] sta-info fixes, especially destroy()
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series should fix the problems with sta_info_destroy() that
Tomas pointed out. Tomas, please give the patches a try, I don't
currently have a suitable IBSS test environment. Especially, it
would be worth trying out making an IBSS mode virtual interface
re-join an IBSS (to test the flush_delayed stuff.)

johannes

