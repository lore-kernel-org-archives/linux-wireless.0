Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:43159 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbZCTTgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:36:12 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's otus)
Date: Fri, 20 Mar 2009 20:36:08 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>, otus-devel@lists.madwifi-project.org
References: <200903170408.12626.chunkeey@web.de>
In-Reply-To: <200903170408.12626.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903202036.09255.chunkeey@web.de> (sfid-20090320_203616_754712_371EE1B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the number of mails I got, this driver should be ready for inclusion.
So, this is probably the last RFC and the official patches will follow on
sunday (only if no one finds a bug that needs to be fixed ASAP.)

Changes:
	- enabled HW crypto acceleration (on by default)
	- report noise and signal levels in dBm
	- sniffer/promiscouous mode now works in BSS
	- LED code rework
	- fixed last remaining checkpatch.pl ERRORs

Features:
	- managed and (full) monitor mode
		(other modes may work too... but were not tested)
	- QoS 
	- tx status => automatic rate control
	- offload for ccmp, tkip & wep
	- programmable LEDs

Note: The whole patch series can be found in the linux-wireless archive.
e.g: http://marc.info/?l=linux-wireless&r=1&b=200903&w=2 

Regards,
	Chr

---
John what's your verdict? would you accept the driver in its current state?
