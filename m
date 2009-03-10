Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZCJC2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:28:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] iw: few pending patches
Date: Mon,  9 Mar 2009 22:28:47 -0400
Message-Id: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032857_536583_255445C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the userspace patches which make use of the
stuff I just sent out for cfg80211.

Luis R. Rodriguez (3):
  iw: parse max allowed bandwidth
  iw: use stdbool on reg.c
  iw: add regulatory events notification parsing

 info.c    |   17 ++++++++++++--
 iw.c      |   47 +++++++++++++++++++++++++++++++++++++++++
 iw.h      |    2 +
 nl80211.h |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reg.c     |   35 ++++++++++++++++++++++-------
 5 files changed, 159 insertions(+), 12 deletions(-)

