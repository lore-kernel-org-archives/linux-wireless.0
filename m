Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47834 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbaK1VGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 16:06:10 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 23:05:53 +0200
Message-Id: <1417208756-14839-1-git-send-email-luca@coelho.fi> (sfid-20141128_220614_548432_2BCD1C79)
Subject: [PATCH iw v3 0/3] add WoWLAN net-detect trigger
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

A third spin.  This one includes parsing of some configuration
information related to net-detect (patch 3/3).  I haven't send the
nl80211 counterpart yet, but it's backwards compatible with the
existing nl80211 code, so it doesn't matter if it's added in iw first.

In v3:
   * removed silly commented out SSID printing stuff
   * added new patch to parse get_wowlan information

In v2:
   * renamed the option in the code from "match" to "matches" (the
     help already used the plural form).

--
Luca.

Luciano Coelho (3):
  update nl80211.h
  add WoWLAN net-detect trigger
  parse net detect wowlan configuration information

 event.c   |  28 +++++++-
 info.c    |   3 +
 nl80211.h | 119 ++++++++++++++++++++++++++++++++--
 wowlan.c  | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 357 insertions(+), 7 deletions(-)

-- 
2.1.3

