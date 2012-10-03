Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:50709
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab2JCEaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 00:30:21 -0400
Message-ID: <506BBF57.8060608@posedge.com> (sfid-20121003_063122_364291_CDD41FB9)
Date: Wed, 3 Oct 2012 10:00:15 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 0/2] mac80211: VHT peer STA caps
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per Johannes review comments on PATCH v3, split into 2 patches and 
removed incomplete code of AP mode saving STA vht caps.

[PATCH v4 1/2]
Rename vht_capabilities to vht_cap

  include/linux/ieee80211.h |    2 +-
  net/mac80211/main.c       |    2 +-
  net/mac80211/mlme.c       |    4 ++--
  net/mac80211/util.c       |    4 ++--
  4 files changed, 6 insertions(+), 6 deletions(-)

[PATCH v4 2/2]
To save APs VHT capabilities in mac80211 under STA mode

  include/net/mac80211.h     |    3 +++
  net/mac80211/Makefile      |    1 +
  net/mac80211/ieee80211_i.h |    7 +++++++
  net/mac80211/mlme.c        |    5 +++++
  net/mac80211/util.c        |   12 ++++++++++++
  net/mac80211/vht.c         |   36 ++++++++++++++++++++++++++++++++++++
  6 files changed, 64 insertions(+), 0 deletions(-)
