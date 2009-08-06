Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZHFSpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:45:21 -0400
Message-Id: <20090806184131.114246687@sipsolutions.net>
Date: Thu, 06 Aug 2009 20:41:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 0/3] roaming/disassoc fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel reported a bug, and it was hard to fix :)

Here's the fix patchset, including another fix
for a bug I noticed while testing.

This requires Pavel's patch, of course, but applies
without it in the tree too.

johannes

