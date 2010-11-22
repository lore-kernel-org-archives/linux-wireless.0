Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28871 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab0KVPAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 10:00:30 -0500
From: luciano.coelho@nokia.com
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] compat-wireless: wl1271->wl12xx rename
Date: Mon, 22 Nov 2010 17:00:26 +0200
Message-Id: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Hi Luis,

I've just sent a pull-request to John with the patch that renames wl1271 to wl12xx and renames some files accordingly.  This breaks compat-wireless as we discussed before, so I have already created this patch that fixes the problems caused by the renaming.

Once the wl12xx rename patch reaches linux-next, you can apply this to the compat-wireless tree.

Thanks!

Cheers,
Luca.

Luciano Coelho (1):
  compat-wireless: apply changes needed after wl1271->wl12xx renaming

 Makefile                             |    4 ++--
 README                               |    2 +-
 patches/06-header-changes.patch      |    4 ++--
 patches/25-multicast-list_head.patch |    4 ++--
 scripts/driver-select                |    6 +++---
 scripts/unload.sh                    |    2 +-
 scripts/wlunload.sh                  |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

