Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0IPNA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 09:00:27 -0400
Message-Id: <20100916125821.369545798@sipsolutions.net>
Date: Thu, 16 Sep 2010 14:58:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 0/2] p2p interface types
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches introduce p2p interface types
so drivers and the stack can distinguish them
from normal station/AP modes. I'm posting another
set of patches for the supplicant to make use of
them.

johannes

