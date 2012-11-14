Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58286 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161168Ab2KNMR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:17:58 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>
Subject: [RFC] debug_hex_dump()
Date: Wed, 14 Nov 2012 14:17:42 +0200
Message-ID: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121114_131801_876259_52829165)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following discussion on linux-wireless,
I separated dynamic hex dump into stand alone patch.

Please review and comment.

Vladimir Kondratiev (1):
  dynamic_debug: introduce debug_hex_dump()

 Documentation/dynamic-debug-howto.txt |    9 +++++++--
 include/linux/dynamic_debug.h         |   10 ++++++++++
 include/linux/printk.h                |   14 ++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

-- 
1.7.10.4

