Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42756 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424959AbeCBJEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 04:04:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-03-02
Date: Fri,  2 Mar 2018 10:04:46 +0100
Message-Id: <20180302090447.31036-1-johannes@sipsolutions.net> (sfid-20180302_101714_768554_715D24D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Just a few more patches, but I'll be travelling over the next
week and probably won't be able to send things to you then.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 93c62c45ed5fad1b87e3a45835b251cd68de9c46:

  rxrpc: Fix send in rxrpc_send_data_packet() (2018-02-22 15:37:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-03-02

for you to fetch changes up to a78872363614367c3f37e3a5b4181c7a6b207b37:

  cfg80211: add missing dependency to CFG80211 suboptions (2018-02-27 10:54:12 +0100)

----------------------------------------------------------------
Three more patches:
 * fix for a regression in 4-addr mode with fast-RX
 * fix for a Kconfig problem with the new regdb
 * fix for the long-standing TCP performance issue in
   wifi using the new sk_pacing_shift_update()

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: drop frames with unexpected DS bits from fast-rx to slow path

Romain Naour (1):
      cfg80211: add missing dependency to CFG80211 suboptions

Toke Høiland-Jørgensen (1):
      mac80211: Adjust TSQ pacing shift

 net/mac80211/rx.c    |  2 +-
 net/mac80211/tx.c    |  8 ++++++++
 net/wireless/Kconfig | 13 +++++--------
 3 files changed, 14 insertions(+), 9 deletions(-)
