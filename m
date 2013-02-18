Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3BROja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:39:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, backports@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] compat-drivers: rename GPL file to COPYING
Date: Mon, 18 Feb 2013 15:39:23 +0100
Message-Id: <1361198363-29244-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_153933_907582_235184B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Code or other references in the kernel would point to
a file called "COPYING" (as in the upstream kernel),
so rename the GPL file to that name.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 COPYRIGHT => COPYING | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename COPYRIGHT => COPYING (100%)

diff --git a/COPYRIGHT b/COPYING
similarity index 100%
rename from COPYRIGHT
rename to COPYING
-- 
1.8.0

