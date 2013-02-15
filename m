Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935142Ab3BOAKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 19:10:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U68sv-000766-I0
	for linux-wireless@vger.kernel.org; Fri, 15 Feb 2013 01:10:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/4] cfg80211: better station change handling
Date: Fri, 15 Feb 2013 01:10:29 +0100
Message-Id: <1360887033-21167-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_011044_014920_7130345F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an attempt to improve station change handling and have
a single place to check parameter validity, like most other
nl80211 APIs.

johannes

