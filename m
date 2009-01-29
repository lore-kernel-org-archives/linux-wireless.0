Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZA2IiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 03:38:18 -0500
Message-Id: <20090129005450.068797016@sipsolutions.net> (sfid-20090129_093821_280305_394EC253)
Date: Thu, 29 Jan 2009 01:54:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: m.sujith@gmail.com, tomasw@gmail.com
Subject: [RFC/RFT 00/11] mac80211 HT code improvements/bug fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few HT things for mac80211, some code restructuring and
improvements, and a few bug fixes for races and for a problem with
aggregation on arbitrary interface types (which the code should not
accept)

Comments and review, but also testing is very much welcome! The
locking is a little intricate unfortunately.

johannes

