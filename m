Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYFSX2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:28:11 -0400
Message-Id: <20080619232229.202159000@sipsolutions.net> (sfid-20080620_012813_782063_FF369338)
Date: Fri, 20 Jun 2008 01:22:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] improve code in TX/RX paths
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As mentioned previously, this improves code size a lot if all the
functions get inlined by the compiler. It actually makes the code
slightly larger in the debug case because now there is code rather
than .data with all the function calls.

The patch series will require the fragmentation fix Tomas sent to
be applied.

johannes

