Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:60602 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030342AbXD2Rs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 13:48:58 -0400
Date: Sun, 29 Apr 2007 19:48:55 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Subject: "Stable" branch of mac80211
Message-ID: <20070429194855.451b9e7c@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've created a new 'stable' branch in my tree
(git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git). It
contains patches that strip mac80211 down to a stable version. The purpose
of this branch is to prepare mac80211 for vanilla inclusion.

Please note that this branch is expected to be rebased frequently and all
patches are subject to change.

Currently, it contains following patches:

      mac80211: remove 802.11n parts
      mac80211: remove WPA testing stuff
      mac80211: remove hostapd ioctls
      mac80211: remove nonstable iwpriv ioctls
      mac80211: remove iwpriv ioctls with wext equivalent
      mac80211: remove AP and WDS support


 Jiri

-- 
Jiri Benc
SUSE Labs
