Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46058 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeAVNPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:15:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-01-22
Date: Mon, 22 Jan 2018 14:15:00 +0100
Message-Id: <20180122131501.21953-1-johannes@sipsolutions.net> (sfid-20180122_141516_248512_74F61848)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

A few more (only four, really) changes have come in, so I figured
since the merge window hasn't opened yesterday, I'd still send them
to you.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 564737f981fb4b4b3266901508bb9b90d9d43de8:

  Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue (2018-01-14 12:25:04 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-01-22

for you to fetch changes up to 0ddcff49b672239dda94d70d0fcf50317a9f4b51:

  mac80211_hwsim: fix possible memory leak in hwsim_new_radio_nl() (2018-01-22 14:03:29 +0100)

----------------------------------------------------------------
Less than a handful of changes:
 * possible memory leak fix in hwsim
 * speed up hwsim
 * add hwsim userspace rate control API
 * code cleanups

----------------------------------------------------------------
Benjamin Beichler (2):
      mac80211_hwsim: add hashtable with mac address keys for faster lookup
      mac80211_hwsim: add hwsim_tx_rate_flags to netlink attributes

Christopher Díaz Riveros (1):
      debugfs_sta: Remove unneeded semicolons

weiyongjun (A) (1):
      mac80211_hwsim: fix possible memory leak in hwsim_new_radio_nl()

 drivers/net/wireless/mac80211_hwsim.c | 95 ++++++++++++++++++++++++++++-------
 drivers/net/wireless/mac80211_hwsim.h | 68 ++++++++++++++++++++++++-
 net/mac80211/debugfs_sta.c            |  4 +-
 3 files changed, 146 insertions(+), 21 deletions(-)
