Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47105 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2I3Qal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:30:41 -0400
Message-Id: <20120930162936.046757966@w1.fi> (sfid-20120930_183125_666301_12D29724)
Date: Sun, 30 Sep 2012 19:29:36 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] cfg80211/mac80211: Station mode SAE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support to allow simultaneous authentication of equals
(SAE) to be implemented in station mode with user space SME.

-- 
Jouni Malinen                                            PGP id EFC895FA
