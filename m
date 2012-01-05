Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2AEPd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:28 -0500
Message-Id: <20120105153043.568616380@sipsolutions.net> (sfid-20120105_163331_675926_A8C28541)
Date: Thu, 05 Jan 2012 16:30:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] more station handling refactoring
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's another set of patches to refactor station
handling, particularly station state handling (and
fix a bug or two in the process).

The major work here is getting rid of dummy stations
again and notifying drivers about state transitions
(but state transition and sta_add/sta_remove callbacks
will be mutually exclusive).

johannes

