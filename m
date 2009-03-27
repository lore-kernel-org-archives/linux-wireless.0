Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZC0EU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:20:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pabs@debian.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] wireless-regdb: few reg updates + new build
Date: Fri, 27 Mar 2009 00:20:52 -0400
Message-Id: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com> (sfid-20090327_052111_930360_9D88B580)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

resending a few reg updates but the last two patches are new.
The last one should hopefully help distributions package
wireless-regdb.

Luis R. Rodriguez (4):
  wireless-regdb: BN was missing two 5 GHz bands
  wireless-regdb: KR few reg updates
  wireless-regdb: fix a couple of comment typos
  wireless-regdb: make distrition packaging easier

 Makefile                            |  106 +++++++++++++++++++++++++++++-----
 db.txt                              |   10 ++-
 key.pub.pem => linville.key.pub.pem |    0
 regulatory.bin                      |  Bin 3080 -> 3088 bytes
 sha1sum.txt                         |    1 +
 5 files changed, 97 insertions(+), 20 deletions(-)
 rename key.pub.pem => linville.key.pub.pem (100%)
 create mode 100644 sha1sum.txt

