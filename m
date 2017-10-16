Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752241AbdJPNqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 09:46:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-10-16
Date: Mon, 16 Oct 2017 15:46:17 +0200
Message-Id: <20171016134618.30810-1-johannes@sipsolutions.net> (sfid-20171016_154629_756685_060BCC6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's a fix, for a small part of the "KRACK" announced today
(krackattacks.com).

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit c0576e3975084d4699b7bfef578613fb8e1144f6:

  net: call cgroup_sk_alloc() earlier in sk_clone_lock() (2017-10-10 20:24:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-10-16

for you to fetch changes up to fdf7cb4185b60c68e1a75e61691c4afdc15dea0e:

  mac80211: accept key reinstall without changing anything (2017-10-16 13:02:03 +0200)

----------------------------------------------------------------
Just a single fix, for a WoWLAN-related part of CVE-2017-13080.

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: accept key reinstall without changing anything

 net/mac80211/key.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)
