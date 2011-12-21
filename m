Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61316 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1LUAHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:07:24 -0500
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 0/2] wireless-regdb: DFS master changes
Date: Tue, 20 Dec 2011 16:04:10 -0800
Message-ID: <1324425852-4492-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111221_010732_615512_32D78354)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Now that DFS master patches are merged for cfg80211 wireless-regdb
can use being updated with support for exposing the DFS region. This
is a repost with no changes made, just a poke.

Zefir may next want to add a patch for whatever country he's looking to
support with ETSI, for example. TI, may want to do the same :D

Luis R. Rodriguez (2):
  wireless-regdb: Add master DFS region support
  wireless-regdb: add FCC as the DFS region for US

 db.txt     |    2 +-
 db2bin.py  |    2 +-
 dbparse.py |   25 ++++++++++++++++++++-----
 3 files changed, 22 insertions(+), 7 deletions(-)

-- 
1.7.4.15.g7811d

