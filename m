Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2JZNSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:18:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TRjoG-0000wE-M7
	for linux-wireless@vger.kernel.org; Fri, 26 Oct 2012 15:18:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/4] multi-channel/interface TX power handling
Date: Fri, 26 Oct 2012 15:19:18 +0200
Message-Id: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151853_919727_1AA2D71B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's v2, keeping handling of phy TX power setting by
telling the driver about it with a NULL wdev.

johannes

