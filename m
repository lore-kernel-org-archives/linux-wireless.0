Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXFVIlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:03 -0400
Message-Id: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] major mac80211 restructuring/cleanups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211.c is just too large to be maintainable. This patch series
splits it up into a few smaller files; it also has a few tiny
buglet-fixes.

