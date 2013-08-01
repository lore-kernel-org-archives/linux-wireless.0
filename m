Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60074 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040Ab3HAAbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 20:31:46 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-hams@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] include/net: next set of extern removals
Date: Wed, 31 Jul 2013 17:31:31 -0700
Message-Id: <cover.1375316912.git.joe@perches.com> (sfid-20130801_024144_769035_A7B58EE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Standardize on no extern use on function prototypes

Joe Perches (8):
  addrconf.h: Remove extern function prototypes
  af_unix.h: Remove extern from function prototypes
  af_rxrpc.h: Remove extern from function prototypes
  arp/neighbour.h: Remove extern from function prototypes
  ax25.h: Remove extern from function prototypes
  cfg80211.h/mac80211.h: Remove extern from function prototypes
  checksum: Remove extern from function prototypes
  cls_cgroup.h netprio_cgroup.h: Remove extern from function prototypes

 include/net/addrconf.h       | 160 +++++++++++++++-----------------
 include/net/af_rxrpc.h       |  35 ++++---
 include/net/af_unix.h        |  16 ++--
 include/net/arp.h            |  30 +++---
 include/net/ax25.h           | 215 ++++++++++++++++++++++---------------------
 include/net/cfg80211.h       |  34 +++----
 include/net/checksum.h       |  10 +-
 include/net/cls_cgroup.h     |   2 +-
 include/net/mac80211.h       |  16 ++--
 include/net/neighbour.h      |  98 ++++++++++----------
 include/net/netprio_cgroup.h |   2 +-
 11 files changed, 300 insertions(+), 318 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

