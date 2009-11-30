Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:64470 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbZK3VJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 16:09:03 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH v3 0/4] Further L2 padding fixes.
Date: Mon, 30 Nov 2009 22:08:14 +0100
Message-Id: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The L2 padding fixes patch has grown a bit and now consists of 4 separate
patches to clean the L2 padding code up and to fix a number of bugs at the
same time.

	1. rt2x00: Further L2 padding fixes.
	2. rt2x00: Remove SKBDESC_L2_PADDED flag.
	3. rt2x00: Reorganize L2 padding inserting function.
	4. rt2x00: Only remove L2 padding in received frames if there is payload.

---
Gertjan.
