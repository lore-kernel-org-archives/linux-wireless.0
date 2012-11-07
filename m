Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGNYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:24:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TW5bz-0003OZ-MG
	for linux-wireless@vger.kernel.org; Wed, 07 Nov 2012 14:24:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: HW reconfiguration improvements
Date: Wed,  7 Nov 2012 14:24:41 +0100
Message-Id: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net> (sfid-20121107_142421_598063_D0830406)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During some work with HW reconfiguration, I found a few issues
and missing features. These patches address them.

johannes

