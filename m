Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43594 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1CTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 22:19:51 -0400
Received: by mail-wi0-f171.google.com with SMTP id h11so3203611wiv.16
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 19:19:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/2] cfg80211: a few genregdb.awk updates
Date: Mon, 28 Oct 2013 03:19:44 +0100
Message-Id: <1382926786-7904-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_031957_213221_A0C78DB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few updates while toying with genregdb.awk for small
regulatory domains. This depends on the antenna gain removal
patch.

Luis R. Rodriguez (2):
  cfg80211: add function helpers to genregdb.awk
  cfg80211: fix parsing when db.txt ends on a rule

 net/wireless/genregdb.awk | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

-- 
1.8.4.rc3

