Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109AbZLOUKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:10:23 -0500
Message-Id: <20091215200618.253970634@sipsolutions.net>
Date: Tue, 15 Dec 2009 21:06:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT 0/5] mac80211: re-enable software retry
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset re-enables software retry of failed/filtered
frames.

At least that's the intention. I haven't actually tested
it at all yet, so it might break crypto completely :)

johannes

