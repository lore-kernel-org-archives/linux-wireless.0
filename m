Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3BTKgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:36:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U872L-0007Ux-TC
	for linux-wireless@vger.kernel.org; Wed, 20 Feb 2013 11:36:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] nl80211: large wiphy information
Date: Wed, 20 Feb 2013 11:36:23 +0100
Message-Id: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net> (sfid-20130220_113636_394783_3A90D952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the patches to support large wiphy information and add
back the information that previously pushed it over the limit.

johannes

