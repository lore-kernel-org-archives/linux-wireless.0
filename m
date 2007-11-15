Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron4-smtp.tops.gwu.edu ([161.253.149.65]:39040 "EHLO
	iron4-smtp.tops.gwu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbXKOBBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 20:01:32 -0500
Subject: Suspend/Resume support
From: Ben Gamari <ben@mw0.ath.cx>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 14 Nov 2007 19:51:45 -0500
Message-Id: <1195087905.3814.11.camel@mercury> (sfid-20071115_010136_704631_7FDFAFA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Some time ago there was discussion on this list regarding suspend/resume
support in mac80211 (See 05 Aug 2007, "suspend/resume support in
mac80211"). The conclusion of this thread was that mac80211 had no
suspend/resume support and that functionality to stop the stack needed
to be added to fully support suspend. Has anyone started working on
implementing this functionality?

If not, precisely what needs to be done to add robust suspend/resume
support to mac80211? Might this be a project that someone not presently
familiar with the mac80211 codebase could tackle with some guidance?
Thanks a ton,

- Ben
