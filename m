Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946621AbXBIQd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:33:26 -0500
Message-Id: <20070209162711.375886000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:27:11 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Subject: [PATCH 0/4] cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series introduces cfg80211 along with the wext compatibility
code. cfg80211 including the wext compat code can be built as a module
so that we can replace it safely without requiring a kernel recompile.

johannes

