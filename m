Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbXHNLuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:50:05 -0400
Message-Id: <20070814093254.021041000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:32:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] hostapd cleanups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains some updates for hostapd, corresponding
to the ioctls removals in the kernel.

I'm not entirely sure about the removal of PRISM2_PARAM_NEXT_MODE
but the API is totally useless at the moment since hardly anything
kernel seems to differentiate between B and G channels and G drivers
don't support B channels.

johannes

