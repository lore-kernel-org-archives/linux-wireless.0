Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2DCI1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 04:27:20 -0400
Message-Id: <20120403082416.559209159@sipsolutions.net> (sfid-20120403_102724_757636_B390B8A7)
Date: Tue, 03 Apr 2012 10:24:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] queue mapping changes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So these changes have now survived more testing internally,
after previous testing showed a few bugs.

The monitor change is necessary to allow drivers to support
injection after the queue mapping changes since otherwise
if we only have monitor interfaces we have no idea which
queues to use.

johannes

