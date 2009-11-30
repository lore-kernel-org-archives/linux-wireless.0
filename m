Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZK3Pnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 10:43:31 -0500
Message-Id: <20091130153857.963079149@sipsolutions.net>
Date: Mon, 30 Nov 2009 16:38:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Spatial multiplexing powersave (client support)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches implement spatial multiplexing power
save along with sending action frames if userspace
requests changes while associated.

The default is being in dynamic SM PS when powersave is
requested, and SM PS turned off when not in powersave.
Right now, only station interfaces are supported.

johannes

