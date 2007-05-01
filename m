Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52056 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751526AbXEAPuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 11:50:37 -0400
Date: Tue, 1 May 2007 17:50:30 +0200
From: Jiri Benc <jbenc@suse.cz>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211: pull request
Message-ID: <20070501175030.2a409e3d@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git up
to obtain following patches:

Jiri Benc (3):
      mac80211: destroy workqueue in error path
      mac80211: rename remaining mentions of sysfs and procfs
      mac80211: mark as experimental

Johannes Berg (1):
      fix mac80211 compile w/o VERBOSE_DEBUG but w/ DEBUG

 net/mac80211/Kconfig          |    3 ++-
 net/mac80211/debugfs_key.c    |    1 -
 net/mac80211/debugfs_netdev.h |    8 ++++----
 net/mac80211/ieee80211.c      |    3 ++-
 net/mac80211/ieee80211_i.h    |    4 +++-
 net/mac80211/sta_info.c       |   34 ++++++++++++++++++++--------------
 net/mac80211/sta_info.h       |    8 +++++---
 7 files changed, 36 insertions(+), 25 deletions(-)


-- 
Jiri Benc
SUSE Labs
